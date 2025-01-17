<!-- Copyright (C) 2012-2024 Zammad Foundation, https://zammad-foundation.org/ -->

<script setup lang="ts">
import { ref } from 'vue'
import type { MaybeElement } from '@vueuse/core'
import ResizeHandle from '#desktop/components/ResizeHandle/ResizeHandle.vue'
import CollapseButton from '#desktop/components/CollapseButton/CollapseButton.vue'
import CommonButton from '#desktop/components/CommonButton/CommonButton.vue'
import { useCollapseHandler } from '#desktop/components/CollapseButton/composables/useCollapseHandler.ts'
import { useResizeWidthHandle } from '#desktop/components/ResizeHandle/composables/useResizeWidthHandle.ts'

interface Props {
  name: string
  collapsible?: boolean
  iconCollapsed?: string
  resizable?: boolean
  id: string
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'resize-horizontal': [number]
  'resize-horizontal-start': [void]
  'resize-horizontal-end': [void]
  'reset-width': [void]
  collapse: [boolean]
  expand: [boolean]
}>()

const { toggleCollapse, isCollapsed } = useCollapseHandler(emit, {
  storageKey: `${props.name}-sidebar-collapsed`,
})

const resizeHandle = ref<MaybeElement>()

const { startResizing } = useResizeWidthHandle(emit, resizeHandle)
</script>

<template>
  <aside
    :id="props.id"
    class="group/sidebar -:bg-neutral-950 relative flex h-full flex-col border-e border-neutral-100 p-3 dark:border-gray-900"
    :class="{
      'px-2': isCollapsed,
    }"
  >
    <CollapseButton
      v-if="collapsible"
      :is-collapsed="isCollapsed"
      :owner-id="id"
      group="sidebar"
      class="absolute top-[49px] z-10 ltr:right-0 ltr:translate-x-1/2 rtl:left-0 rtl:-translate-x-1/2"
      @toggle-collapse="toggleCollapse"
    />
    <ResizeHandle
      v-if="resizable && !isCollapsed"
      ref="resizeHandle"
      class="absolute top-1/2 -translate-y-1/2 ltr:right-0 rtl:left-0"
      :aria-label="$t('resize sidebar')"
      @mousedown="startResizing"
      @touchstart="startResizing"
      @dblclick="$emit('reset-width')"
      @resize-horizontal-start="$emit('resize-horizontal-start')"
      @resize-horizontal-end="$emit('resize-horizontal-end')"
    />
    <CommonButton
      v-if="iconCollapsed && isCollapsed"
      class="mx-auto"
      size="medium"
      data-test-id="action-button"
      variant="neutral"
      :icon="iconCollapsed"
      @click="toggleCollapse"
    />
    <slot v-else v-bind="{ isCollapsed }" />
  </aside>
</template>
