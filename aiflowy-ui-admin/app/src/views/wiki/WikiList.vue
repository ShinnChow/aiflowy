<script setup lang="ts">
import type { FormInstance } from 'element-plus';

import type { ActionButton } from '#/components/page/CardList.vue';

import { computed, onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';

import { $t } from '@aiflowy/locales';

import { Delete, Edit, Plus, View } from '@element-plus/icons-vue';
import {
  ElButton,
  ElDialog,
  ElForm,
  ElFormItem,
  ElInput,
  ElInputNumber,
  ElMessage,
  ElMessageBox,
  ElOption,
  ElSelect,
} from 'element-plus';
import { tryit } from 'radash';

import { api } from '#/api/request';
import defaultIcon from '#/assets/ai/knowledge/book.svg';
import HeaderSearch from '#/components/headerSearch/HeaderSearch.vue';
import CardList from '#/components/page/CardList.vue';
import PageData from '#/components/page/PageData.vue';
import PageSide from '#/components/page/PageSide.vue';
import WikiOptimizer from '#/components/wiki/WikiOptimizer.vue';

const router = useRouter();

interface FieldDefinition {
  prop: string;
  label: string;
  type?: 'input' | 'number' | 'select' | 'textarea';
  required?: boolean;
  placeholder?: string;
}

const actions: ActionButton[] = [
  {
    icon: Edit,
    text: $t('button.edit'),
    className: '',
    permission: '/api/v1/wiki/save',
    onClick(row: any) {
      showDialog(row);
    },
  },
  {
    icon: View,
    text: $t('button.view'),
    className: '',
    permission: '',
    onClick(row: any) {
      toDetailPage(row);
    },
  },
  {
    icon: Delete,
    text: $t('button.delete'),
    className: 'item-danger',
    permission: '/api/v1/wiki/remove',
    onClick(row: any) {
      handleDelete(row);
    },
  },
];

onMounted(() => {
  getCategoryList();
});

const pageDataRef = ref();
const headerButtons = [
  {
    key: 'create',
    text: $t('button.add'),
    icon: Plus,
    type: 'primary',
    data: { action: 'create' },
    permission: '/api/v1/wiki/save',
  },
];

const handleSearch = (params: string) => {
  pageDataRef.value.setQuery({ title: params, isQueryOr: true });
};

function reset() {
  pageDataRef.value.setQuery({});
}

function showDialog(row: any) {
  wikiFormRef.value?.resetFields();
  wikiFormData.value = { ...row, type: 1, parentId: 0 };
  wikiDialogVisible.value = true;
}

function toDetailPage(row: any) {
  router.push({
    name: 'WikiDetail',
    query: { id: row.id },
  });
}

const handleDelete = (item: any) => {
  ElMessageBox.confirm($t('message.deleteAlert'), $t('message.noticeTitle'), {
    confirmButtonText: $t('message.ok'),
    cancelButtonText: $t('message.cancel'),
    type: 'warning',
    beforeClose: (action, instance, done) => {
      if (action === 'confirm') {
        instance.confirmButtonLoading = true;
        api
          .post('/api/v1/wiki/remove', { id: item.id })
          .then((res) => {
            instance.confirmButtonLoading = false;
            if (res.errorCode === 0) {
              ElMessage.success(res.message);
              reset();
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
};

const handleHeaderButtonClick = (data: any) => {
  if (data.data.action === 'create') {
    showDialog({});
  }
};

// === Category side ===
const categoryList = ref<any[]>([]);
const getCategoryList = async () => {
  const [, res] = await tryit(api.get)('/api/v1/wikiCategory/list', {
    params: { sortKey: 'sortNo', sortType: 'asc' },
  });
  if (res && res.errorCode === 0) {
    categoryList.value = [
      {
        id: '',
        categoryName: $t('common.allCategories'),
      },
      ...res.data,
    ];
  }
};

function changeCategory(category: any) {
  pageDataRef.value.setQuery({ categoryId: category.id });
}

// === Category CRUD ===
const categoryFieldDefinitions = ref<FieldDefinition[]>([
  {
    prop: 'categoryName',
    label: $t('aiWorkflowCategory.categoryName'),
    type: 'input',
    required: true,
    placeholder: $t('aiWorkflowCategory.categoryName'),
  },
  {
    prop: 'sortNo',
    label: $t('aiWorkflowCategory.sortNo'),
    type: 'number',
    required: false,
    placeholder: $t('aiWorkflowCategory.sortNo'),
  },
]);

const categoryFormData = ref<any>({});
const categoryDialogVisible = ref(false);
const categoryFormRef = ref<FormInstance>();
const categorySaveLoading = ref(false);

const categoryFormRules = computed(() => {
  const rules: Record<string, any[]> = {};
  categoryFieldDefinitions.value.forEach((field) => {
    const fieldRules = [];
    if (field.required) {
      fieldRules.push({
        required: true,
        message: `${$t('message.required')}`,
        trigger: 'blur',
      });
    }
    if (fieldRules.length > 0) {
      rules[field.prop] = fieldRules;
    }
  });
  return rules;
});

function showCategoryDialog(item: any) {
  categoryFormRef.value?.resetFields();
  categoryFormData.value = { ...item };
  categoryDialogVisible.value = true;
}

function removeCategory(row: any) {
  ElMessageBox.confirm($t('message.deleteAlert'), $t('message.noticeTitle'), {
    confirmButtonText: $t('message.ok'),
    cancelButtonText: $t('message.cancel'),
    type: 'warning',
    beforeClose: (action, instance, done) => {
      if (action === 'confirm') {
        instance.confirmButtonLoading = true;
        api
          .post('/api/v1/wikiCategory/remove', { id: row.id })
          .then((res) => {
            instance.confirmButtonLoading = false;
            if (res.errorCode === 0) {
              ElMessage.success(res.message);
              done();
              getCategoryList();
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

function handleCategorySubmit() {
  categoryFormRef.value?.validate((valid) => {
    if (valid) {
      categorySaveLoading.value = true;
      const url = categoryFormData.value.id
        ? '/api/v1/wikiCategory/update'
        : '/api/v1/wikiCategory/save';
      api.post(url, categoryFormData.value).then((res) => {
        categorySaveLoading.value = false;
        if (res.errorCode === 0) {
          getCategoryList();
          ElMessage.success(res.message);
          categoryDialogVisible.value = false;
        }
      });
    }
  });
}

const controlBtns = [
  {
    icon: Edit,
    label: $t('button.edit'),
    onClick(row: any) {
      showCategoryDialog(row);
    },
  },
  {
    type: 'danger',
    icon: Delete,
    label: $t('button.delete'),
    onClick(row: any) {
      removeCategory(row);
    },
  },
];

const footerButton = {
  icon: Plus,
  label: $t('button.add'),
  onClick() {
    showCategoryDialog({});
  },
};

// === Wiki dialog (edit top-level directory) ===
const wikiFormData = ref<any>({});
const wikiDialogVisible = ref(false);
const wikiFormRef = ref<FormInstance>();
const wikiSaveLoading = ref(false);

const wikiFormRules = {
  title: [
    {
      required: true,
      message: `${$t('message.required')}`,
      trigger: 'blur',
    },
  ],
};

function handleWikiSubmit() {
  wikiFormRef.value?.validate((valid) => {
    if (valid) {
      wikiSaveLoading.value = true;
      const url = wikiFormData.value.id
        ? '/api/v1/wiki/update'
        : '/api/v1/wiki/save';
      api
        .post(url, { ...wikiFormData.value, type: 1, parentId: 0 })
        .then((res) => {
          wikiSaveLoading.value = false;
          if (res.errorCode === 0) {
            ElMessage.success(res.message);
            wikiDialogVisible.value = false;
            reset();
          }
        });
    }
  });
}
</script>

<template>
  <div class="flex h-full flex-col gap-6 p-6">
    <HeaderSearch
      :buttons="headerButtons"
      @search="handleSearch"
      @button-click="handleHeaderButtonClick"
    />
    <div class="flex max-h-[calc(100vh-191px)] flex-1 gap-6">
      <PageSide
        label-key="categoryName"
        value-key="id"
        :menus="categoryList"
        :control-btns="controlBtns"
        :footer-button="footerButton"
        @change="changeCategory"
      />
      <div class="h-full flex-1 overflow-auto">
        <PageData
          ref="pageDataRef"
          page-url="/api/v1/wiki/page"
          :page-size="12"
          :page-sizes="[12, 24, 36, 48]"
          :extra-query-params="{ parentId: 0, type: 1 }"
        >
          <template #default="{ pageList }">
            <CardList
              :default-icon="defaultIcon"
              title-key="title"
              desc-key="description"
              :data="pageList"
              :actions="actions"
            />
          </template>
        </PageData>
      </div>
    </div>

    <!-- Category Dialog -->
    <ElDialog
      v-model="categoryDialogVisible"
      :title="
        categoryFormData.id ? `${$t('button.edit')}` : `${$t('button.add')}`
      "
      :close-on-click-modal="false"
    >
      <ElForm
        ref="categoryFormRef"
        :model="categoryFormData"
        :rules="categoryFormRules"
        label-width="120px"
      >
        <ElFormItem
          v-for="field in categoryFieldDefinitions"
          :key="field.prop"
          :label="field.label"
          :prop="field.prop"
        >
          <ElInput
            v-if="!field.type || field.type === 'input'"
            v-model="categoryFormData[field.prop]"
            :placeholder="field.placeholder"
          />
          <ElInputNumber
            v-else-if="field.type === 'number'"
            v-model="categoryFormData[field.prop]"
            :placeholder="field.placeholder"
            style="width: 100%"
          />
        </ElFormItem>
      </ElForm>
      <template #footer>
        <ElButton @click="categoryDialogVisible = false">
          {{ $t('button.cancel') }}
        </ElButton>
        <ElButton
          type="primary"
          @click="handleCategorySubmit"
          :loading="categorySaveLoading"
        >
          {{ $t('button.confirm') }}
        </ElButton>
      </template>
    </ElDialog>

    <!-- Wiki Edit Dialog -->
    <ElDialog
      v-model="wikiDialogVisible"
      :title="wikiFormData.id ? `${$t('button.edit')}` : `${$t('button.add')}`"
      :close-on-click-modal="false"
    >
      <ElForm
        ref="wikiFormRef"
        :model="wikiFormData"
        :rules="wikiFormRules"
        label-width="120px"
      >
        <ElFormItem :label="$t('wiki.title')" prop="title">
          <WikiOptimizer
            class="mb-1"
            v-model="wikiFormData.title"
            field="title"
            :type="wikiFormData.type"
            :wiki-id="wikiFormData.id"
          />
          <ElInput
            v-model="wikiFormData.title"
            :placeholder="$t('wiki.placeholder.title')"
          />
        </ElFormItem>
        <ElFormItem :label="$t('wiki.category')" prop="categoryId">
          <ElSelect
            v-model="wikiFormData.categoryId"
            :placeholder="$t('wiki.placeholder.category')"
            clearable
            style="width: 100%"
          >
            <ElOption
              v-for="item in categoryList.filter((c) => c.id)"
              :key="item.id"
              :label="item.categoryName"
              :value="item.id"
            />
          </ElSelect>
        </ElFormItem>
        <ElFormItem :label="$t('wiki.description')" prop="description">
          <WikiOptimizer
            class="mb-1"
            v-model="wikiFormData.description"
            field="description"
            :type="wikiFormData.type"
            :wiki-id="wikiFormData.id"
          />
          <ElInput
            v-model="wikiFormData.description"
            type="textarea"
            :rows="8"
            :maxlength="500"
            show-word-limit
            :placeholder="$t('wiki.placeholder.description')"
            :style="{ height: '120px' }"
          />
        </ElFormItem>
      </ElForm>
      <template #footer>
        <ElButton @click="wikiDialogVisible = false">
          {{ $t('button.cancel') }}
        </ElButton>
        <ElButton
          type="primary"
          @click="handleWikiSubmit"
          :loading="wikiSaveLoading"
        >
          {{ $t('button.confirm') }}
        </ElButton>
      </template>
    </ElDialog>
  </div>
</template>

<style scoped></style>
