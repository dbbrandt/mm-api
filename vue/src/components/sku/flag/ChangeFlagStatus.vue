<template>
<div :class='{ flagged: flag, selected: selected, unselected: !selected }'>
  <DateTime v-if="hasTimestamp" :value='timestamp' :timeIfToday='true'/>
  <div v-else>&nbsp;</div>
</div>
</template>

<script>
import dateUtil from '@/util/date';

export default {
  name: 'ChangeFlagStatus',
  props: ['flag', 'timestamp', 'selected'],
  computed: {
    hasTimestamp() {
      return dateUtil.isValid(this.timestamp);
    },
  },
};
</script>

<style scoped>
  .flagged {
    background-color: lightgreen;
  }
  .selected {
    border: 1px dashed #2980b9;
  }
  .unselected {
    border: 1px solid transparent;
  }
</style>
