<template>
  <v-icon :title="status">{{icon}}</v-icon>
</template>
<script>

export default {
  name: 'Id',
  props: ['status'],
  computed: {
    icon() {
      let icon;
      switch (this.status) {
        case 'failed':
          icon = 'error_outline';
          break;
        case 'processed':
          icon = 'check';
          break;
        case 'skipped':
          icon = 'redo';
          break;
        case 'pending':
          icon = 'hourglass_empty';
          break;
        default:
          break;
      }
      return icon;
    },
  },
};
</script>
\
