<template>
  <span>{{instanceSuffix}}</span>
</template>
<script>
const DEFAULT_SUFFIX = 's';

export default {
  name: 'Pluralize',
  props: ['count', 'suffix'],
  computed: {
    instanceSuffix() {
      return this.count === 1 ? '' : this.suffix || DEFAULT_SUFFIX;
    },
  },
};
</script>
