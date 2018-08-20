<template>
  <div>
    <Selector :initialIds="initialIds" :initialType="initialType" :unrecognizedIds="unrecognizedIds"></Selector>

    <input type="checkbox" id="active_only" v-model="isActiveOnly">
    <label for="active_only">Active Only</label>
    <input type="checkbox" id="newest_for_sku" v-model="isNewestForSku">
    <label for="newest_for_sku">Newest for SKU</label>
    <br><br>
    <div v-if="isLoading">
      <Spinner msg='loading Price and Cost Change Requests'/>
    </div>
    <div v-else>
      <template v-if="sku">
        <h1><span class="subtle-label">sku</span> {{sku.name}}</h1>
        <div>
          <Id type='sku'>
            <router-link :to="{ path: 'view-sku-images', query: { sku_id: sku.sku_id }}">{{sku.sku_id}}</router-link>
          </Id>
          <Id type='bbb sku'>
            <router-link :to="{ path: 'view-sku-images', query: { bbb_sku_id: sku.bbb_sku_id }}">{{sku.bbb_sku_id}}</router-link>
          </Id>
          <Id type='product'>
            <router-link :to="{ path: 'view-sku-images', query: { product_id: sku.product_id }}">{{sku.product_id}}</router-link>
          </Id>
          <Id type='base product'>
            <router-link :to="{ path: 'view-sku-images', query: { base_product_id: sku.base_product_id }}">{{sku.base_product_id}}</router-link>
          </Id>
        </div>
        <span class="subtle-label">modified</span> <DateTime :value='sku.modified_date'/>
        <span class="subtle-label">created</span> <DateTime :value='sku.created_date'/>
        <br>
        <span class="subtle-label">price</span> {{sku.price}}
        <span class="subtle-label">cost</span> {{sku.cost}}
        <br>
        <span class="subtle-label" v-if="sku.pre_markdown_price">strikethrough</span> {{sku.pre_markdown_price}}
        <span class="subtle-label" v-if="sku.clearance">clearance</span> {{sku.clearance}}
        <br>
        <span class="subtle-label">auto clearance</span> {{sku.is_auto_clearance}}
        <span class="subtle-label" v-if="pendingClearance">pending clearance</span> {{pendingClearance}}
        <span class="subtle-label" v-if="sku.revert_clearance">revert clearance</span> {{sku.revert_clearance}}
      </template>
      <template v-else-if="priceAndCostChangeRequests.length">
        <div v-if="apiLimited" class="api-limit-reached">api limit reached; there may be more than {{apiLimit(api)}} results</div>
        {{priceAndCostChangeRequests.length}} matching Price and Cost Change Request<Pluralize :count='priceAndCostChangeRequests.length'></Pluralize>
        for {{loadedIds.length}} {{idTypeDisplay}}<Pluralize :count='loadedIds.length'></Pluralize>, most recent first
      </template>
      <br>

      <template v-if="priceAndCostChangeRequests.length">
        <v-btn class="pull-right" flat v-on:click="loadPriceAndCostChangeRequestsDebounced">refresh</v-btn>
        <PriceRequestsTable :priceRequests="priceAndCostChangeRequests"
                            :showSkuId="!sku"
                            v-on:refreshItem="updatePriceAndCostChangeRequest"
        />
      </template>
    </div>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex';
import Id from '@/components/Id';
import Selector from '@/components/sku/Selector';
import PriceRequestsTable from '@/components/sku/pca/PriceRequestsTable';
import skuUtil from '@/util/sku';
import settingUtil from '@/util/setting';
import _ from 'lodash';

const DELAY_MS = 500;
const ID_TYPE_OKL_SKU_ID = 'sku_id';
const initialIsActiveOnlySetting = settingUtil.load('PRICE_REQUESTS.ACTIVE_ONLY');

export default {
  name: 'price-requests',
  components: {
    Id,
    Selector,
    PriceRequestsTable,
  },
  data() {
    return {
      api: 'price_and_cost_change_request',
      unrecognizedIds: [],
      isLoading: false,
      isActiveOnly: !initialIsActiveOnlySetting || initialIsActiveOnlySetting === 'true',
      isNewestForSku: settingUtil.load('PRICE_REQUESTS.NEWEST_FOR_SKU') === 'true',
    };
  },
  watch: {
    selectionIds() {
      this.loadPriceAndCostChangeRequestsDebounced();
    },
    selectionType() {
      this.loadPriceAndCostChangeRequestsDebounced();
    },
    isActiveOnly() {
      settingUtil.save('PRICE_REQUESTS.ACTIVE_ONLY', this.isActiveOnly);
      this.loadPriceAndCostChangeRequestsDebounced();
    },
    isNewestForSku() {
      settingUtil.save('PRICE_REQUESTS.NEWEST_FOR_SKU', this.isNewestForSku);
      this.loadPriceAndCostChangeRequestsDebounced();
    },
  },
  methods: {
    loadPriceAndCostChangeRequestsDebounced:
      _.debounce(function go() {
        if (this.selectionIds.length) {
          this.loadPriceAndCostChangeRequests(this.selectionIds, this.selectionType);
        } else {
          this.unrecognizedIds = [];
        }
      }, DELAY_MS),
    loadPriceAndCostChangeRequests(ids, idType) {
      this.isLoading = true;
      this.unrecognizedIds = [];
      const activeOnly = this.isActiveOnly;
      const newestForSku = this.isNewestForSku;
      this.findPriceAndCostChangeRequestsForSku({ ids, idType, activeOnly, newestForSku })
        .then(() => {
          this.unrecognizedIds = _.difference(ids, this.loadedIds);

          if (this.isSingleSkuId) {
            // load details for spotlighted sku
            this.findSku({ id: this.loadedIds[0], idType });
          } else {
            this.clearSku();
          }
        }).finally(() => {
          this.isLoading = false;
        });
    },
    ...mapActions([
      'findPriceAndCostChangeRequestsForSku',
      'updatePriceAndCostChangeRequest',
      'findSku',
      'clearSku',
    ]),
  },
  computed: {
    ...mapGetters([
      'priceAndCostChangeRequests',
      'selection',
      'sku',
      'apiLimit',
    ]),
    selectionIds() {
      return this.selection.ids;
    },
    selectionType() {
      return this.selection.type;
    },
    loadedIds() {
      return _.uniq((this.priceAndCostChangeRequests || []).map(pccr => pccr[this.selectionType]));
    },
    isSingleSkuId() {
      return this.loadedIds.length === 1;
    },
    initialIds() {
      let ids = [];
      const querySkuId = this.$route.query.sku_id;
      if (querySkuId) {
        if (querySkuId.split) {
          // parse string as one or possibly multiple sku ids
          // TODO support upc_ean and okl_sku here (low priority...)
          ids = querySkuId.split(',').map(id => parseInt(id, 10));
        } else {
          // coerce a single sku id to an array for consistency
          ids = [querySkuId];
        }
      }
      return ids;
    },
    initialType() {
      let initialType;
      if (this.initialIds && this.initialIds.length) {
        initialType = ID_TYPE_OKL_SKU_ID;
      }
      return initialType;
    },
    idTypeDisplay() {
      return skuUtil.labelForIdType(this.selectionType);
    },
    pendingOrApprovedPriceAndCostChangeRequest() {
      return this.sku
        && this.priceAndCostChangeRequests.filter(pccr => ['pending', 'approved'].includes(pccr.status))[0];
    },
    pendingClearance() {
      return this.pendingOrApprovedPriceAndCostChangeRequest &&
        this.pendingOrApprovedPriceAndCostChangeRequest.pending_clearance;
    },
    apiLimited() {
      return this.loadedIds.length === this.apiLimit(this.api);
    },
  },
};
</script>

<style lang="scss" scoped>
@import "~@/scss/global";

.subtle-label {
  color: grey;
}

h1 {
  font-weight: normal;
}

.pull-right {
  float: right;
}

label:first-of-type {
  margin-right: 20px;
}

</style>
