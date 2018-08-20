<template>
  <a :href="'/' + link" :title="label">
    <span v-bind:class="['nav-icon', `icon-${icon}`]"></span>
    <span class="nav-label">{{label}}</span>
  </a>
</template>

<script>
export default {
  props: ['link', 'label', 'icon'],
  name: 'legacy-icon',
};
</script>
