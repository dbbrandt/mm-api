<template>
  <div class="id-container">
    <span class="value"><slot></slot></span><br>
    <span class="type">{{type}}</span>
  </div>
</template>
<script>

export default {
  name: 'Id',
  props: ['type'],
};
</script>

<style lang="scss" scoped>
  @import "~@/scss/global";

  .id-container {
    display: inline-block;
    text-align: left;
    padding: 10px;
    .type {
      color: purple;
      font-size: 14px;
    }
    .value {
      font-size: 20px;
    }
  }
</style>
