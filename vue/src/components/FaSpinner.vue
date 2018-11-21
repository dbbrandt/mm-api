<template>
  <span>
    <template v-if="msg">
      {{msg}}...
    </template>
    <icon name="circle-o-notch" spin/>
  </span>
</template>

<script>
export default {
  props: ['msg'],
};
</script>