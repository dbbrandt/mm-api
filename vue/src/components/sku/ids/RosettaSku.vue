<template>
  <div>
    <img src="../../../assets/Rosetta_Stone.png" class="rosetta-stone" title="Rosetta Stone"/>
    <Selector :unrecognizedIds="unrecognizedIds" :initialIds="selection.ids"></Selector>
    <div v-if="isLoadingSkus">
      <Spinner msg='loading SKUs'/>
    </div>
    <div v-else>
      <template v-if="skus.length">
        {{skus.length}} SKU<Pluralize :count='skus.length'></Pluralize>
        <div v-if="apiLimited" class="api-limit-reached">api limit reached; there may be more than {{apiLimit(api)}} results</div>
        <div class="u-align-right">
          as of <DateTime :value='loadTime' :timeIfToday='true'/>
          <v-btn flat v-on:click="loadSkusForIds">refresh</v-btn>
        </div>
        <SkuIdsTable :skus=skus></SkuIdsTable>
      </template>
    </div>
  </div>
</template>

<script>
import _ from 'lodash';
import SkuIdsTable from '@/components/sku/ids/SkuIdsTable';
import Selector from '@/components/sku/Selector';
import api from '@/api';
import { mapGetters } from 'vuex';

const DELAY_MS = 500;

export default {
  name: 'rosetta-sku',
  components: {
    SkuIdsTable,
    Selector,
  },
  data() {
    return {
      api: 'sku',
      skus: [],
      isLoadingSkus: false,
      unrecognizedIds: [],
      loadTime: null,
    };
  },
  computed: {
    ...mapGetters([
      'selection',
      'apiLimit',
    ]),
    selectionIds() {
      return this.selection.ids;
    },
    selectionType() {
      return this.selection.type;
    },
    loadedIds() {
      return (this.skus || []).map(sku => sku[this.selectionType]);
    },
    apiLimited() {
      return this.loadedIds.length === this.apiLimit(this.api);
    },
  },
  watch: {
    selectionIds() {
      this.loadSkusForIdsDebounced();
    },
    selectionType() {
      this.loadSkusForIdsDebounced();
    },
  },
  methods: {
    loadSkusForIdsDebounced: _.debounce(function go() { this.loadSkusForIds(); }, DELAY_MS),
    loadSkusForIds() {
      if (this.selectionIds.length) {
        this.unrecognizedIds = [];
        this.isLoadingSkus = true;
        api.sku.find(this.selectionIds, this.selectionType)
          .then(({ skus: skuChangeFlags }) => {
            this.skus = skuChangeFlags;
            this.unrecognizedIds = _.difference(this.selectionIds, this.loadedIds);
            this.loadTime = new Date();
          }).finally(() => {
            this.isLoadingSkus = false;
          });
      } else {
        this.skus = [];
      }
    },
  },
};
</script>

<style lang="scss" scoped>
  @import "~@/scss/global";

  .rosetta-stone {
    height: 200px;
    position: absolute;
    bottom: 5px;
    left: 70px;
    opacity: 0.3;
  }

</style>
