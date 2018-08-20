<template>
  <span>
    <template v-if="msg">
      {{msg}}...
    </template>
    <v-progress-circular indeterminate color="purple" class="u-vertical-align-middle"></v-progress-circular>
  </span>
</template>

<script>
export default {
  props: ['msg'],
};
</script>
