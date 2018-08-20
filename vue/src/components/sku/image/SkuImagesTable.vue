<template>
  <table>
    <thead>
      <tr>
        <th>bbb sku id</th>
        <th>okl sku id</th>
        <th>upc ean</th>
        <th>product id</th>
        <th>base product id</th>
        <th>okl sku</th>
        <th>name</th>
        <th>created</th>
        <th>modified</th>
        <th>images</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="sku in skus">
        <td><router-link :to="{ path: 'view-sku-images', query: { bbb_sku_id: sku.bbb_sku_id }}">{{sku.bbb_sku_id}}</router-link></td>
        <td>
          <router-link :to="{ path: 'view-sku-images', query: { sku_id: sku.sku_id }}">{{sku.sku_id}}</router-link>
          <router-link v-if='$store.getters.isPowerUser' :to="{ path: 'pca', query: { sku_id: sku.sku_id }}">PCA</router-link>
        </td>
        <td><router-link :to="{ path: 'view-sku-images', query: { upc_ean: sku.upc_ean }}">{{sku.upc_ean}}</router-link></td>
        <td><router-link :to="{ path: 'view-sku-images', query: { product_id: sku.product_id }}">{{sku.product_id}}</router-link></td>
        <td><router-link :to="{ path: 'view-sku-images', query: { base_product_id: sku.base_product_id }}">{{sku.base_product_id}}</router-link></td>
        <td><router-link :to="{ path: 'view-sku-images', query: { okl_sku: sku.okl_sku }}">{{sku.okl_sku}}</router-link></td>
        <td class="u-align-left">{{sku.name}}</td>
        <td><DateTime :value='sku.created_date'></DateTime></td>
        <td><DateTime :value='sku.modified_date'></DateTime></td>
        <td>
          <div class="image-tile" v-for="image in sku.images">
            <img :src="`${image}?fit=constrain,1&wid=70&hei=70&fmt=jpg`" class="u-vertical-align-middle"/>
            {{image}}
          </div>
        </td>
      </tr>
    </tbody>
  </table>
</template>

<script>

export default {
  name: 'SkuImagesTable',
  props: ['skus'],
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>
@import "~@/scss/global";

a {
  color: #2980b9;
}

table {
  width: 100%;
  overflow: hidden;
  background-color: white;
}

td, th {
  position: relative;
}

tr {
  height: 75px;
}

table tr:nth-child(odd) td{
  background-color: #f2faff;
}

.u-vertical-align-middle {
  vertical-align: middle;
}

.image-tile {
  margin: 2px;
}
</style>
