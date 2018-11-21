<template>
  <div>
    <Selector :unrecognizedIds="unrecognizedIds"></Selector>

    <div v-if="isLoadingSkus">
      <Spinner msg='loading SKUs'/>
    </div>
    <div v-else>
      <template v-if="skus.length">

        <div>
          <Spinner msg='setting change flags' v-bind:class="{'u-invisible': !isSettingFlags}"/><br>
          <v-btn color="primary" v-on:click="update" v-bind:class="[{ 'u-invisible': !canUpdate }, 'btn']">Set {{updateableCount}} Change Flags</v-btn>
        </div>

        {{skus.length}} SKU<Pluralize :count='skus.length'></Pluralize>
        <div style="float: right">
          as of <DateTime :value='loadTime' :timeIfToday='true'/>
          <v-btn flat v-on:click="loadSkusForIds">refresh</v-btn>
        </div>
        <SkuChangeFlagsTable :skuChangeFlags=skus></SkuChangeFlagsTable>
      </template>
    </div>
  </div>
</template>

<script>
import _ from 'lodash';
import moment from 'moment';
import SkuChangeFlagsTable from '@/components/sku/flag/SkuChangeFlagsTable';
import Selector from '@/components/sku/Selector';
import api from '@/api';
import flags from '@/util/flag';
import { mapGetters } from 'vuex';

const DELAY_MS = 500;
const FLAGS = flags.enum;

export default {
  name: 'flag-skus',
  components: {
    SkuChangeFlagsTable,
    Selector,
  },
  data() {
    return {
      skus: [],
      isLoadingSkus: false,
      isSettingFlags: false,
      unrecognizedIds: [],
      loadTime: null,
    };
  },
  computed: {
    ...mapGetters([
      'selection',
    ]),
    selectionIds() {
      return this.selection.ids;
    },
    selectionType() {
      return this.selection.type;
    },
    canUpdate() {
      return this.updateableCount > 0 && this.updatingFlags.length && !this.isSettingFlags;
    },
    updateableCount() {
      let count = 0;
      (this.skus || []).forEach((sku) => {
        const { selected } = sku;
        if (selected) {
          Object.keys(selected).forEach((key) => {
            if (selected[key] && FLAGS[key]) {
              count += 1;
            }
          });
        }
      });
      return count;
    },
    updatingFlags() {
      const updatingFlags = [];
      (this.skus || []).forEach((sku) => {
        const { selected } = sku;
        if (selected) {
          Object.keys(selected).forEach((key) => {
            if (selected[key] && FLAGS[key]) {
              updatingFlags.push(key);
            }
          });
        }
      });
      return _.uniq(updatingFlags);
    },
    loadedIds() {
      return (this.skus || []).map(sku => (this.selectionType === 'base_product_id' ? sku.base_product[this.selectionType] : sku[this.selectionType]));
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
    update() {
      this.isSettingFlags = true;
      api.skuChangeFlag.update(this.skus, this.updatingFlags.join(',')).then(() => {
        this.loadSkusForIds();
      }).finally(() => {
        this.isSettingFlags = false;
      });
    },
    loadSkusForIdsDebounced: _.debounce(function go() { this.loadSkusForIds(); }, DELAY_MS),
    loadSkusForIds() {
      if (this.selectionIds.length) {
        this.unrecognizedIds = [];
        this.isLoadingSkus = true;
        api.skuChangeFlag.find(this.selectionIds, this.selectionType)
          .then(({ sku_change_flags: skuChangeFlags }) => {
            skuChangeFlags.forEach((scf) => {
              scf.selected = {};
              Object.keys(FLAGS).forEach((flag) => {
                const key = `${flag}_timestamp`;
                scf.created_date = moment(scf.created_date).toDate();
                scf.modified_date = moment(scf.modified_date).toDate();
                scf[key] = moment(scf[key]).toDate();
                scf.selected[flag] = false;
              });
              scf.base_product.clean_timestamp = moment(scf.base_product.clean_timestamp).toDate();
              scf.base_product.storefront_ready_timestamp =
                moment(scf.base_product.storefront_ready_timestamp).toDate();
            });
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
