<script setup lang="ts">
import { ref } from 'vue';

import { $t } from '@aiflowy/locales';

import {
  ElButton,
  ElDialog,
  ElForm,
  ElFormItem,
  ElIcon,
  ElInput,
  ElMessage,
} from 'element-plus';

import { sseClient } from '#/api/request';
import MagicStaffIcon from '#/components/icons/MagicStaffIcon.vue';

interface Props {
  modelValue?: string;
  buttonText?: string;
  field: string;
  type: number;
  wikiId: string;
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: '',
  systemPrompt: '',
  choreContent: '',
  buttonText: 'button.optimize',
});

const emit = defineEmits(['update:modelValue']);

const dialogVisible = ref(false);
const optimizedContent = ref('');
const loading = ref(false);

const openDialog = () => {
  optimizedContent.value = props.modelValue;
  const content = optimizedContent.value || props.modelValue || '';
  if (!content) {
    ElMessage.warning('内容不能为空');
    return;
  }
  dialogVisible.value = true;
  handleSubmit();
};

const handleSubmit = async () => {
  loading.value = true;
  const content = optimizedContent.value || props.modelValue || '';
  const data = {
    field: props.field,
    type: props.type,
    wikiId: props.wikiId,
    originValue: content,
  };
  optimizedContent.value = '';
  sseClient.post('/api/v1/wiki/optimizeTitleOrDesc', data, {
    onMessage(message) {
      const event = message.event;
      if (event === 'done') {
        loading.value = false;
        return;
      }
      if (!message.data) {
        return;
      }
      const sseData = JSON.parse(message.data);
      const delta = sseData.payload?.delta;
      optimizedContent.value += delta;
    },
  });
};

const handleReplace = () => {
  emit('update:modelValue', optimizedContent.value);
  dialogVisible.value = false;
};

const handleCancel = () => {
  dialogVisible.value = false;
};
</script>

<template>
  <div class="prompt-chore-wrapper">
    <button
      @click="openDialog"
      type="button"
      class="flex items-center gap-0.5 rounded-lg bg-[#F7F7F7] px-3 py-1"
    >
      <ElIcon size="16"><MagicStaffIcon /></ElIcon>
      <span
        class="whitespace-nowrap bg-[linear-gradient(106.75666073298856deg,#F17E47,#D85ABF,#717AFF)] bg-clip-text text-sm text-transparent"
      >
        {{ $t('bot.aiOptimization') }}
      </span>
    </button>

    <ElDialog
      v-model="dialogVisible"
      :title="$t('bot.aiOptimizedPrompts')"
      draggable
      align-center
      width="550px"
      append-to-body
    >
      <ElForm>
        <ElFormItem>
          <ElInput type="textarea" :rows="20" v-model="optimizedContent" />
        </ElFormItem>
      </ElForm>

      <template #footer>
        <ElButton @click="handleCancel">
          {{ $t('button.cancel') }}
        </ElButton>
        <ElButton type="primary" @click="handleReplace" :disabled="loading">
          {{ $t('button.replace') }}
        </ElButton>
        <ElButton
          type="primary"
          :loading="loading"
          :disabled="loading"
          @click="handleSubmit"
        >
          {{ loading ? $t('button.optimizing') : $t('button.regenerate') }}
        </ElButton>
      </template>
    </ElDialog>
  </div>
</template>

<style scoped>
.prompt-chore-wrapper {
  display: inline-block;
}
</style>
