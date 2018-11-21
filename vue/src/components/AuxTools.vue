<template>
  <ul class="menu-pane">
    <li v-if='$store.getters.isPowerUser'>
      <router-link to="flag-skus">Flag SKUs</router-link>
    </li>
    <li v-if="$store.getters.hasRole('mega_buyer') || $store.getters.isPowerUser">
      <router-link to="pca">Price and Cost Change Requests</router-link>
    </li>
    <li>
      <router-link to="rosetta-sku">Rosetta SKU</router-link>
    </li>
  </ul>
</template>

<script>
  export default {
    name: 'aux-tools',
  };
</script>

<style lang="scss" scoped>
  .menu-pane {
    padding-top: 200px;
    padding-left: 20px;
    margin: auto;
    width: 33%;
    text-align: left;
    font-size: 18px;
  }
</style>
