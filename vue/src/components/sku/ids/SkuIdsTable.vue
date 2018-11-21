<template>
  <div>
    <div class="u-align-right">
      <a :href='downloadLink' :download='downloadFilename' class="u-text-decoration-none table-control"><v-icon title="Download as CSV">file_download</v-icon></a>
      <button type="button"
              v-clipboard:copy="copyData"
              v-clipboard:success="onCopy"
              v-clipboard:error="onError"
              class="table-control">
        <v-icon title="Copy">content_copy</v-icon>
      </button>
    </div>
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
        </tr>
      </thead>
      <tbody>
        <tr v-for="scf in skus">
          <td><router-link :to="{ path: 'view-sku-images', query: { bbb_sku_id: scf.bbb_sku_id }}">{{scf.bbb_sku_id}}</router-link></td>
          <td>
            <router-link v-if="!$store.getters.isPowerUser" :to="{ path: 'view-sku-images', query: { sku_id: scf.sku_id }}">{{scf.sku_id}}</router-link>
            <router-link v-if="$store.getters.isPowerUser" :to="{ path: 'view-a-sku/' + scf.sku_id}">{{scf.sku_id}}</router-link>
          </td>
          <td><router-link :to="{ path: 'view-sku-images', query: { upc_ean: scf.upc_ean }}">{{scf.upc_ean}}</router-link></td>
          <td><router-link :to="{ path: 'view-sku-images', query: { product_id: scf.product_id }}">{{scf.product_id}}</router-link></td>
          <td><router-link :to="{ path: 'view-sku-images', query: { base_product_id: scf.base_product_id }}">{{scf.base_product_id}}</router-link></td>
          <td><router-link :to="{ path: 'view-sku-images', query: { okl_sku: scf.okl_sku }}">{{scf.okl_sku}}</router-link></td>
          <td class="u-align-left">{{scf.name}}</td>
          <td><DateTime :value='scf.created_date'></DateTime></td>
          <td><DateTime :value='scf.modified_date'></DateTime></td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import moment from 'moment';
import StorefrontLink from '@/components/sku/StorefrontLink';

const escapeDelimiter = (input, delimiter) => {
  const regex = new RegExp(delimiter, 'g');
  return typeof input === 'string' ? input.replace(regex, '') : input;
};

const delimitData = (skus, delimiter) => {
  const fields = ['name', 'bbb_sku_id', 'sku_id', 'base_product_id', 'upc_ean', 'product_id', 'okl_sku'];
  const data = [`${fields.join(delimiter)}`];
  skus.forEach((sku) => {
    const values = fields.map(field => escapeDelimiter(sku[field], delimiter));
    data.push(values.join(delimiter));
  });
  return data.join('\n');
};

export default {
  name: 'SkuIdsTable',
  props: ['skus'],
  components: {
    StorefrontLink,
  },
  methods: {
    onCopy() {
      // console.log('onCopy');
    },
    onError(error) {
      window.alert(`Copy Failed: ${error}`);
    },
  },
  computed: {
    downloadData() {
      return delimitData(this.skus, ',');
    },
    copyData() {
      return delimitData(this.skus, '\t');
    },
    downloadLink() {
      return `data:text/csv;charset=utf-8,${encodeURIComponent(this.downloadData)}`;
    },
    downloadFilename() {
      const skuCount = this.skus && this.skus.length;
      return `rosetta-sku-${skuCount}-identifier${skuCount !== 1 ? 's' : ''}-${moment().format('YYYY-MM-DD-HHmm[h]')}.csv`;
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

.table-control {
  margin: 0px 5px 5px;
  &:last-child {
    margin-right: 25px;
  }
}

</style>
