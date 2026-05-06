<script setup lang="ts">
import type { FormInstance, UploadFile } from 'element-plus';

import { computed, onMounted, ref, watch } from 'vue';
import { useRoute } from 'vue-router';

import { useAppConfig } from '@aiflowy/hooks';
import { IconifyIcon } from '@aiflowy/icons';
import { $t } from '@aiflowy/locales';
import { useAccessStore } from '@aiflowy/stores';

import {
  CirclePlus,
  Delete,
  Download,
  Edit,
  FolderOpened,
  MoreFilled,
  Plus,
  UploadFilled,
} from '@element-plus/icons-vue';
import {
  ElButton,
  ElDialog,
  ElDropdown,
  ElDropdownItem,
  ElDropdownMenu,
  ElForm,
  ElFormItem,
  ElIcon,
  ElInput,
  ElMessage,
  ElMessageBox,
  ElOption,
  ElSelect,
  ElSpace,
  ElTable,
  ElTableColumn,
  ElText,
  ElTree,
  ElUpload,
} from 'element-plus';
import { tryit } from 'radash';

import { api } from '#/api/request';
import PageData from '#/components/page/PageData.vue';
import WikiOptimizer from '#/components/wiki/WikiOptimizer.vue';
import { useDictStore } from '#/store';
import { getFileType } from '#/utils/file';

const route = useRoute();
const wikiId = ref<string>((route.query.id as string) || '');
const dictStore = useDictStore();

const { apiURL } = useAppConfig(import.meta.env, import.meta.env.PROD);
const accessStore = useAccessStore();
const headers = ref({
  'aiflowy-token': accessStore.accessToken,
});

// 初始化字典
const initDict = () => {
  dictStore.fetchDictionary('recognitionMode');
  dictStore.fetchDictionary('ocrTaskStatus');
};

// === Tree data (type=1 directories) ===
const treeData = ref<any[]>([]);
const selectedTreeNode = ref<any>(null);

// 懒加载：缓存 node 对象，便于刷新
const treeNodeMap = new Map<string, any>();

const loadNode = async (node: any, resolve: (data: any[]) => void) => {
  if (node.level === 0) {
    return resolve([
      {
        id: wikiId.value,
        title: '全部',
      },
    ]);
  }

  const [, res] = await tryit(api.get)('/api/v1/wiki/list', {
    params: { type: 1, asTree: false, parentId: node.data.id },
  });
  if (res && res.errorCode === 0) {
    const list = res.data || [];
    // 缓存节点数据，id -> node 引用
    if (node.level > 0 && node.data?.id) {
      treeNodeMap.set(node.data.id, node);
    }
    resolve(list);
  } else {
    resolve([]);
  }
};

/** 刷新指定节点的子节点 */
function refreshNode(parentId: string) {
  const node = treeNodeMap.get(parentId);
  if (node) {
    node.loaded = false;
    node.loading = false;
    node.childNodes = [];
    node.expand();
  }
}

/** 刷新根节点 */
function refreshRoot() {
  const root = treeRef.value?.store.root;
  if (root) {
    root.loaded = false;
    root.loading = false;
    root.childNodes = [];
    root.expand();
  }
}

const treeRef = ref<InstanceType<typeof ElTree>>();

function handleNodeClick(data: any, node: any) {
  // 展开/折叠节点，触发懒加载
  if (node.expanded) {
    node.collapse();
  } else {
    node.expand();
  }
  if (selectedTreeNode.value?.id === data.id) {
    // 点击已选中节点，取消选中
    selectedTreeNode.value = null;
    treeRef.value?.setCurrentKey(null);
    pageDataRef.value.setQuery({ parentId: wikiId.value });
  } else {
    selectedTreeNode.value = data;
    pageDataRef.value.setQuery({ parentId: data.id });
  }
}

// === Directory CRUD (type=1) ===
const dirFormData = ref<any>({ type: 1, parentId: 0 });
const dirDialogVisible = ref(false);
const dirFormRef = ref<FormInstance>();
const dirSaveLoading = ref(false);
const dirDialogTitle = ref('');

const dirFormRules = computed(() => ({
  title: [{ required: true, message: $t('message.required'), trigger: 'blur' }],
}));

function addRootDir() {
  dirFormRef.value?.resetFields();
  dirFormData.value = { type: 1, parentId: wikiId.value };
  dirDialogTitle.value = $t('wiki.directory.addRoot');
  dirDialogVisible.value = true;
}

function addChildDir(parentNode: any) {
  dirFormRef.value?.resetFields();
  dirFormData.value = { type: 1, parentId: parentNode.id };
  dirDialogTitle.value = $t('wiki.directory.addChild');
  dirDialogVisible.value = true;
}

function editDir(node: any) {
  dirFormRef.value?.resetFields();
  dirFormData.value = { ...node };
  dirDialogTitle.value = $t('wiki.directory.edit');
  dirDialogVisible.value = true;
}

function removeDir(node: any) {
  ElMessageBox.confirm($t('message.deleteAlert'), $t('message.noticeTitle'), {
    confirmButtonText: $t('message.ok'),
    cancelButtonText: $t('message.cancel'),
    type: 'warning',
    beforeClose: (action, instance, done) => {
      if (action === 'confirm') {
        instance.confirmButtonLoading = true;
        api
          .post('/api/v1/wiki/remove', { id: node.id })
          .then((res) => {
            instance.confirmButtonLoading = false;
            if (res.errorCode === 0) {
              ElMessage.success(res.message);
              // 刷新父节点
              const parentNode = treeNodeMap.get(node.parentId);
              if (parentNode) {
                refreshNode(node.parentId);
                pageDataRef.value?.setQuery({ parentId: node.parentId });
              } else {
                refreshRoot();
                pageDataRef.value?.setQuery({ parentId: wikiId.value });
              }
              done();
            }
          })
          .catch(() => {
            instance.confirmButtonLoading = false;
          });
      } else {
        done();
      }
    },
  }).catch(() => {});
}

function handleDirSubmit() {
  dirFormRef.value?.validate((valid) => {
    if (valid) {
      dirSaveLoading.value = true;
      const isEdit = !!dirFormData.value.id;
      const url = dirFormData.value.id
        ? '/api/v1/wiki/update'
        : '/api/v1/wiki/save';
      api.post(url, dirFormData.value).then((res) => {
        dirSaveLoading.value = false;
        if (res.errorCode === 0) {
          ElMessage.success(res.message);
          dirDialogVisible.value = false;
          if (isEdit) {
            // 编辑：刷新父节点
            const parentId = dirFormData.value.parentId;
            if (parentId === wikiId.value) {
              refreshRoot();
              pageDataRef.value?.setQuery({ parentId: wikiId.value });
            } else {
              refreshNode(parentId);
              pageDataRef.value?.setQuery({ parentId });
            }
          } else {
            // 新增：刷新父节点
            const parentId = dirFormData.value.parentId;
            if (parentId === wikiId.value) {
              refreshRoot();
              pageDataRef.value?.setQuery({ parentId: wikiId.value });
            } else {
              refreshNode(parentId);
              pageDataRef.value?.setQuery({ parentId });
            }
          }
        }
      });
    }
  });
}

// === Right side: Wiki document list (type=2) ===
const pageDataRef = ref();

// Document CRUD (type=2)
const docFormData = ref<any>({ type: 2 });
const docDialogVisible = ref(false);
const docFormRef = ref<FormInstance>();
const docSaveLoading = ref(false);
const isEditMode = ref(false);

// 查看内容模态框
const contentViewVisible = ref(false);
const currentContent = ref('');

// 打开内容查看模态框
function openContentView(row: any) {
  if (row.type === 1) {
    handleTableRowClick(row);
  } else {
    currentContent.value = row.content || '';
    contentViewVisible.value = true;
  }
}

// 识别模式选项
const recognitionModeOptions = [
  { label: $t('wiki.recognition.normal'), value: 1 },
  { label: $t('wiki.recognition.ocr'), value: 2 },
];

// OCR模型列表
const ocrModelList = ref<any[]>([]);

// 获取OCR模型列表
const getOcrModelList = async () => {
  const [, res] = await tryit(api.get)('/api/v1/model/list', {
    params: { modelType: 'ocrModel' },
  });
  if (res && res.errorCode === 0) {
    ocrModelList.value = res.data || [];
  }
};

// 文件上传相关
const docFileList = ref<UploadFile[]>([]);
const uploadedFilePath = ref('');

const docFormRules = computed(() => {
  const rules: any = {
    title: [
      { required: true, message: $t('message.required'), trigger: 'blur' },
    ],
    description: [
      { required: true, message: $t('message.required'), trigger: 'blur' },
    ],
  };

  // 添加模式时才需要验证文件、识别模式和OCR模型
  if (!isEditMode.value) {
    rules.fileUrl = [
      { required: true, message: $t('wiki.upload.file'), trigger: 'change' },
    ];
    rules.recognitionMode = [
      {
        required: true,
        message: $t('wiki.recognition.placeholder'),
        trigger: 'change',
      },
    ];

    // OCR模式下需要选择OCR模型
    if (docFormData.value.recognitionMode === 2) {
      rules.ocrModelId = [
        {
          required: true,
          message: $t('wiki.ocrModelPlaceholder'),
          trigger: 'change',
        },
      ];
    }
  }

  return rules;
});

function addDoc() {
  docFormRef.value?.resetFields();
  const parentId = selectedTreeNode.value?.id || wikiId.value || 0;
  docFormData.value = { type: 2, parentId, recognitionMode: 1 };
  docFileList.value = [];
  uploadedFilePath.value = '';
  isEditMode.value = false;
  getOcrModelList();
  docDialogVisible.value = true;
}

function showDocDialog(row: any) {
  if (row.type === 1) {
    editDir(row);
  } else {
    docFormRef.value?.resetFields();
    docFormData.value = { ...row };
    docFileList.value = [];
    uploadedFilePath.value = '';
    isEditMode.value = true;
    docDialogVisible.value = true;
  }
}

function removeDoc(row: any) {
  if (row.type === 1) {
    removeDir(row);
    return;
  }

  ElMessageBox.confirm($t('message.deleteAlert'), $t('message.noticeTitle'), {
    confirmButtonText: $t('message.ok'),
    cancelButtonText: $t('message.cancel'),
    type: 'warning',
    beforeClose: (action, instance, done) => {
      if (action === 'confirm') {
        instance.confirmButtonLoading = true;
        api
          .post('/api/v1/wiki/remove', { id: row.id })
          .then((res) => {
            instance.confirmButtonLoading = false;
            if (res.errorCode === 0) {
              ElMessage.success(res.message);
              pageDataRef.value.setQuery({});
              done();
            }
          })
          .catch(() => {
            instance.confirmButtonLoading = false;
          });
      } else {
        done();
      }
    },
  }).catch(() => {});
}

// 文件上传成功回调
const handleDocFileSuccess = (response: any) => {
  if (response && response.data && response.data.path) {
    uploadedFilePath.value = response.data.path;
    docFormData.value.fileUrl = response.data.path;
    docFormRef.value?.validateField('fileUrl');
  }
};

// 文件状态变化回调
const handleDocFileChange = (_: UploadFile, fileList: UploadFile[]) => {
  docFileList.value = fileList;
};

// 识别模式变化
const handleRecognitionModeChange = () => {
  if (docFormData.value.recognitionMode !== 2) {
    docFormData.value.ocrModelId = undefined;
  }
};

function handleDocSubmit() {
  docFormRef.value?.validate((valid) => {
    if (valid) {
      docSaveLoading.value = true;
      const url = docFormData.value.id
        ? '/api/v1/wiki/update'
        : '/api/v1/wiki/save';
      api.post(url, docFormData.value).then((res) => {
        docSaveLoading.value = false;
        if (res.errorCode === 0) {
          ElMessage.success(res.message);
          docDialogVisible.value = false;
          pageDataRef.value.setQuery({});
        }
      });
    }
  });
}

async function handleTableRowClick(row: any) {
  if (row.type === 1) {
    // 获取目标节点
    let node = treeRef.value?.getNode(row.id);

    // 如果节点不存在，需要先展开父节点来加载它
    if (!node) {
      const parentNode = treeRef.value?.getNode(row.parentId);
      if (parentNode) {
        // 展开父节点以加载子节点
        if (!parentNode.expanded) {
          await new Promise<void>((resolve) => {
            parentNode.expand(() => {
              resolve();
            });
          });
        }
        // 展开后重新获取目标节点
        node = treeRef.value?.getNode(row.id);
      }
    }

    // 如果找到节点，展开它
    if (node && !node.expanded) {
      node.expand();
    }

    // 选中左侧树节点
    treeRef.value?.setCurrentKey(row.id);
    // 更新选中的树节点数据
    selectedTreeNode.value = row;
    // 更新右侧表格数据为该目录下的内容
    pageDataRef.value?.setQuery({ parentId: row.id });
  }
}

function downloadFile(fileUrl: string) {
  window.open(fileUrl, '_blank');
}

// Watch route id
watch(
  () => route.query.id,
  (newId) => {
    if (newId) {
      wikiId.value = newId as string;
    }
  },
);

onMounted(() => {
  // 懒加载模式，树会自动触发 loadNode 加载根节点
  initDict();
});
</script>

<template>
  <div class="flex h-full gap-4 p-6">
    <!-- Left: Directory Tree -->
    <div
      class="flex w-[200px] flex-shrink-0 flex-col rounded-lg border border-[var(--el-border-color)] bg-[var(--el-bg-color)]"
    >
      <div
        class="flex items-center justify-between border-b border-[var(--el-border-color)] px-4 py-3"
      >
        <span class="text-base font-medium">{{
          $t('wiki.directory.structure')
        }}</span>
        <ElButton type="primary" :icon="Plus" size="small" @click="addRootDir">
          {{ $t('wiki.directory.add') }}
        </ElButton>
      </div>
      <div class="flex-1 overflow-auto p-2">
        <ElTree
          ref="treeRef"
          :data="treeData"
          node-key="id"
          lazy
          :load="loadNode"
          :props="{ label: 'title' }"
          highlight-current
          @node-click="handleNodeClick"
        >
          <template #default="{ node, data }">
            <div class="group flex flex-1 items-center justify-between">
              <ElSpace :size="4">
                <ElIcon><FolderOpened /></ElIcon>
                <span class="truncate">{{ node.label }}</span>
              </ElSpace>
              <span
                class="hidden items-center group-hover:inline-flex"
                @click.stop
              >
                <ElButton
                  :icon="CirclePlus"
                  size="small"
                  link
                  @click="addChildDir(data)"
                />
                <ElButton
                  class="!ml-0"
                  :icon="Edit"
                  size="small"
                  link
                  @click="editDir(data)"
                />
                <ElButton
                  class="!ml-0"
                  :icon="Delete"
                  size="small"
                  link
                  type="danger"
                  @click="removeDir(data)"
                />
              </span>
            </div>
          </template>
        </ElTree>
      </div>
    </div>

    <!-- Right: Wiki Document List -->
    <div
      class="flex flex-1 flex-col gap-4 overflow-auto bg-[var(--el-bg-color)] p-4"
    >
      <div class="flex items-center justify-between">
        <div class="flex items-center gap-2 text-base font-medium">
          <ElIcon><FolderOpened /></ElIcon>
          <span>{{ selectedTreeNode?.title || $t('wiki.document.all') }}</span>
        </div>
        <ElButton type="primary" :icon="Plus" @click="addDoc">
          {{ $t('wiki.document.add') }}
        </ElButton>
      </div>
      <PageData
        ref="pageDataRef"
        page-url="/api/v1/wiki/page"
        :page-size="12"
        :page-sizes="[12, 24, 36, 48]"
        :extra-query-params="{ parentId: wikiId }"
      >
        <template #default="{ pageList }">
          <ElTable
            :data="pageList"
            border
            style="width: 100%"
            @row-click="handleTableRowClick"
          >
            <ElTableColumn :label="$t('wiki.document.title')">
              <template #default="{ row }">
                <ElSpace :size="4">
                  <template v-if="row.type === 1">
                    <ElIcon size="20"><FolderOpened /></ElIcon>
                  </template>
                  <template v-else>
                    <ElIcon size="20">
                      <IconifyIcon :icon="`svg:${getFileType(row.fileUrl)}`" />
                    </ElIcon>
                  </template>
                  <span>{{ row.title }}</span>
                </ElSpace>
              </template>
            </ElTableColumn>
            <ElTableColumn :label="$t('wiki.description')">
              <template #default="{ row }">
                <ElText line-clamp="2">{{ row.description }}</ElText>
              </template>
            </ElTableColumn>
            <ElTableColumn
              prop="created"
              width="180"
              :label="$t('wiki.document.createTime')"
            />
            <ElTableColumn
              :label="$t('common.handle')"
              width="90"
              align="right"
            >
              <template #default="{ row }">
                <div class="flex items-center gap-3">
                  <div class="flex items-center">
                    <ElButton
                      link
                      type="primary"
                      @click.stop="openContentView(row)"
                    >
                      {{ $t('button.view') }}
                    </ElButton>
                  </div>

                  <ElDropdown>
                    <ElButton link :icon="MoreFilled" />

                    <template #dropdown>
                      <ElDropdownMenu>
                        <ElDropdownItem @click.stop="showDocDialog(row)">
                          <ElButton link :icon="Edit">
                            {{ $t('button.edit') }}
                          </ElButton>
                        </ElDropdownItem>
                        <ElDropdownItem
                          v-if="row.fileUrl && row.fileUrl.length > 0"
                          @click.stop="downloadFile(row.fileUrl)"
                        >
                          <ElButton link :icon="Download">
                            {{ $t('button.download') }}
                          </ElButton>
                        </ElDropdownItem>
                        <ElDropdownItem @click.stop="removeDoc(row)">
                          <ElButton link :icon="Delete" type="danger">
                            {{ $t('button.delete') }}
                          </ElButton>
                        </ElDropdownItem>
                      </ElDropdownMenu>
                    </template>
                  </ElDropdown>
                </div>
              </template>
            </ElTableColumn>
          </ElTable>
        </template>
      </PageData>
    </div>

    <!-- Directory Edit Dialog -->
    <ElDialog
      v-model="dirDialogVisible"
      :title="dirDialogTitle"
      :close-on-click-modal="false"
    >
      <ElForm
        ref="dirFormRef"
        :model="dirFormData"
        :rules="dirFormRules"
        label-width="100px"
      >
        <ElFormItem :label="$t('wiki.directory.name')" prop="title">
          <WikiOptimizer
            class="mb-1"
            v-model="dirFormData.title"
            field="title"
            :type="dirFormData.type"
            :wiki-id="dirFormData.id"
          />
          <ElInput
            v-model="dirFormData.title"
            :placeholder="$t('wiki.directory.placeholder')"
          />
        </ElFormItem>
        <ElFormItem :label="$t('wiki.description')" prop="description">
          <WikiOptimizer
            class="mb-1"
            v-model="dirFormData.description"
            field="description"
            :type="dirFormData.type"
            :wiki-id="dirFormData.id"
          />
          <ElInput
            v-model="dirFormData.description"
            type="textarea"
            :rows="8"
            :maxlength="500"
            show-word-limit
            :placeholder="$t('wiki.placeholder.description')"
          />
        </ElFormItem>
      </ElForm>
      <template #footer>
        <ElButton @click="dirDialogVisible = false">
          {{ $t('button.cancel') }}
        </ElButton>
        <ElButton
          type="primary"
          @click="handleDirSubmit"
          :loading="dirSaveLoading"
        >
          {{ $t('button.confirm') }}
        </ElButton>
      </template>
    </ElDialog>

    <!-- Document Edit Dialog -->
    <ElDialog
      v-model="docDialogVisible"
      :title="isEditMode ? $t('button.edit') : $t('button.add')"
      :close-on-click-modal="false"
    >
      <ElForm
        ref="docFormRef"
        :model="docFormData"
        :rules="docFormRules"
        label-width="100px"
      >
        <ElFormItem
          v-if="isEditMode"
          :label="$t('wiki.document.title')"
          prop="title"
        >
          <WikiOptimizer
            class="mb-1"
            v-model="docFormData.title"
            field="title"
            :type="docFormData.type"
            :wiki-id="docFormData.id"
          />
          <ElInput
            v-model="docFormData.title"
            :placeholder="$t('wiki.document.placeholder')"
          />
        </ElFormItem>
        <ElFormItem
          v-if="isEditMode"
          :label="$t('wiki.description')"
          prop="description"
        >
          <WikiOptimizer
            class="mb-1"
            v-model="docFormData.description"
            field="description"
            :type="docFormData.type"
            :wiki-id="docFormData.id"
          />
          <ElInput
            v-model="docFormData.description"
            type="textarea"
            :rows="8"
            :maxlength="500"
            show-word-limit
            :placeholder="$t('wiki.placeholder.description')"
          />
        </ElFormItem>
        <!-- 添加模式才显示文件上传、识别模式和OCR模型 -->
        <template v-if="!isEditMode">
          <ElFormItem :label="$t('wiki.upload.file')" prop="fileUrl">
            <ElUpload
              v-model:file-list="docFileList"
              class="upload-demo"
              drag
              :headers="headers"
              :action="`${apiURL}/api/v1/commons/upload`"
              :on-success="handleDocFileSuccess"
              :on-change="handleDocFileChange"
              :limit="1"
            >
              <ElIcon size="48" color="hsl(var(--primary))">
                <UploadFilled />
              </ElIcon>
              <div class="flex flex-col gap-1">
                <span class="text-base">{{ $t('wiki.upload.tip') }}</span>
                <span class="text-sm text-[#75808d]">
                  {{ $t('wiki.upload.format') }}
                </span>
              </div>
            </ElUpload>
          </ElFormItem>
          <ElFormItem
            :label="$t('wiki.recognition.mode')"
            prop="recognitionMode"
          >
            <ElSelect
              v-model="docFormData.recognitionMode"
              :placeholder="$t('wiki.recognition.placeholder')"
              @change="handleRecognitionModeChange"
            >
              <ElOption
                v-for="item in recognitionModeOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </ElSelect>
          </ElFormItem>
          <ElFormItem
            v-if="docFormData.recognitionMode === 2"
            :label="$t('wiki.ocrModel')"
            prop="ocrModelId"
          >
            <ElSelect
              v-model="docFormData.ocrModelId"
              :placeholder="$t('wiki.ocrModelPlaceholder')"
            >
              <ElOption
                v-for="item in ocrModelList"
                :key="item.id"
                :label="item.title"
                :value="item.id"
              />
            </ElSelect>
          </ElFormItem>
        </template>
      </ElForm>
      <template #footer>
        <ElButton @click="docDialogVisible = false">
          {{ $t('button.cancel') }}
        </ElButton>
        <ElButton
          type="primary"
          @click="handleDocSubmit"
          :loading="docSaveLoading"
        >
          {{ $t('button.confirm') }}
        </ElButton>
      </template>
    </ElDialog>

    <!-- Content View Dialog -->
    <ElDialog
      v-model="contentViewVisible"
      :title="$t('wiki.document.viewContent')"
      :close-on-click-modal="false"
      width="800px"
    >
      <ElXMarkdown :markdown="currentContent" />
      <template #footer>
        <ElButton @click="contentViewVisible = false">
          {{ $t('button.close') }}
        </ElButton>
      </template>
    </ElDialog>
  </div>
</template>

<style scoped>
:deep(.el-tree-node__content) {
  height: 36px;
}
</style>
