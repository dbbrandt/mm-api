<template>
  <table>
    <thead>
      <tr>
        <th>site</th>
        <th>bbb sku id</th>
        <th>okl sku id</th>
        <th>upc ean</th>
        <th>product id</th>
        <th>base product id</th>
        <th>okl sku</th>
        <th>clean</th>
        <th>storefront ready</th>
        <th>name</th>
        <th>created</th>
        <th>modified</th>
        <th><a @click="select('item_master')" class="u-clickable">item master</a></th>
        <th><a @click="select('fulfillment')" class="u-clickable">fulfillment</a></th>
        <th><a @click="select('storefront')" class="u-clickable">storefront</a></th>
        <th><a @click="select('storefront_delete')" class="u-clickable">storefront_delete</a></th>
        <th><a @click="select('vmf_inventory')" class="u-clickable">vmf inventory</a></th>
        <th><a @click="select('pricing')" class="u-clickable">pricing</a></th>
        <th><a @click="select('storefront_inventory')" class="u-clickable">storefront inventory</a></th>
        <th><a @click="select('attribute_generation')" class="u-clickable">attribute generation</a></th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="scf in skuChangeFlags">
        <td><StorefrontLink :is_base_product='scf.is_base_product_storefront_ready' :product_id='scf.product_id' :base_product_id='scf.base_product.base_product_id'></StorefrontLink></td>
        <td><router-link :to="{ path: 'view-sku-images', query: { bbb_sku_id: scf.bbb_sku_id }}">{{scf.bbb_sku_id}}</router-link></td>
        <td>
          <router-link :to="{ path: 'view-a-sku/' + scf.sku_id}">{{scf.sku_id}}</router-link>
          <router-link :to="{ path: 'pca', query: { sku_id: scf.sku_id }}">PCA</router-link>
        </td>
        <td><router-link :to="{ path: 'view-sku-images', query: { upc_ean: scf.upc_ean }}">{{scf.upc_ean}}</router-link></td>
        <td><router-link :to="{ path: 'view-sku-images', query: { product_id: scf.product_id }}">{{scf.product_id}}</router-link></td>
        <td><router-link :to="{ path: 'view-sku-images', query: { base_product_id: scf.base_product.base_product_id }}">{{scf.base_product.base_product_id}}</router-link></td>
        <td><router-link :to="{ path: 'view-sku-images', query: { okl_sku: scf.okl_sku }}">{{scf.okl_sku}}</router-link></td>
        <td><ChangeFlagStatus :flag='scf.base_product.is_clean' :timestamp='scf.base_product.clean_timestamp'/></td>
        <td><ChangeFlagStatus :flag='scf.base_product.is_storefront_ready' :timestamp='scf.base_product.storefront_ready_timestamp'/></td>
        <td class="u-align-left">{{scf.name}}</td>
        <td><DateTime :value='scf.created_date'></DateTime></td>
        <td><DateTime :value='scf.modified_date'></DateTime></td>
        <td>
          <ChangeFlagStatus :flag='scf.item_master' :timestamp='scf.item_master_timestamp' :selected='scf.selected.item_master'/>
        </td>
        <td>
          <ChangeFlagStatus :flag='scf.fulfillment' :timestamp='scf.fulfillment_timestamp' :selected='scf.selected.fulfillment'/>
        </td>
        <td>
          <ChangeFlagStatus :flag='scf.storefront' :timestamp='scf.storefront_timestamp' :selected='scf.selected.storefront'/>
        </td>
        <td>
          <ChangeFlagStatus :flag='scf.storefront_delete' :timestamp='scf.storefront_delete_timestamp' :selected='scf.selected.storefront_delete'/>
        </td>
        <td>
          <ChangeFlagStatus :flag='scf.vmf_inventory' :timestamp='scf.vmf_inventory_timestamp' :selected='scf.selected.vmf_inventory'/>
        </td>
        <td>
          <ChangeFlagStatus :flag='scf.pricing' :timestamp='scf.pricing_timestamp' :selected='scf.selected.pricing'/>
        </td>
        <td>
          <ChangeFlagStatus :flag='scf.storefront_inventory' :timestamp='scf.storefront_inventory_timestamp' :selected='scf.selected.storefront_inventory'/>
        </td>
        <td>
          <ChangeFlagStatus :flag='scf.attribute_generation' :timestamp='scf.attribute_generation_timestamp' :selected='scf.selected.attribute_generation'/>
        </td>
      </tr>
    </tbody>
  </table>
</template>

<script>
import ChangeFlagStatus from '@/components/sku/flag/ChangeFlagStatus';
import StorefrontLink from '@/components/sku/StorefrontLink';

export default {
  name: 'SkuChangeFlagsTable',
  props: ['skuChangeFlags'],
  components: {
    ChangeFlagStatus,
    StorefrontLink,
  },
  methods: {
    select(type) {
      this.skuChangeFlags.forEach((scf) => {
        scf.selected[type] = !scf.selected[type];
      });
    },
  },
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

table tr:nth-child(odd) td{
  background-color: #f2faff;
}

</style>
