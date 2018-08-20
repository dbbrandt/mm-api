<template>
  <span>
    <template v-if="condition">
      <!-- show content as a link -->
      <router-link :to="to"><slot></slot></router-link>
    </template>
    <template v-else>
      <!-- show content as unadorned text -->
      <slot></slot>
    </template>
  </span>
</template>

<script>
export default {
  props: ['condition', 'to'],
};
</script>
