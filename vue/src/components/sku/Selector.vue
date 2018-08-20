<template>
  <div>
    <textarea v-model="skuIdsRaw" placeholder="Enter SKU IDs, separated with spaces or commas"></textarea>

    <div class="id-type-toggle">
      <span>
        <input type="radio" id="id_type_bbb_sku_id" value="bbb_sku_id" v-model="idType">
        <label for="id_type_bbb_sku_id" title="Interpret as BBB SKU IDs (e.g. 77451234)">BBB</label>
      </span>
      <span>
        <input type="radio" id="id_type_okl_sku_id" value="sku_id" v-model="idType">
        <label for="id_type_okl_sku_id" title="Interpret as OKL SKU IDs (e.g. 2451234)">OKL</label>
      </span>
      <span>
        <input type="radio" id="id_type_product_id" value="product_id" v-model="idType">
        <label for="id_type_product_id" title="Interpret as OKL Product Ids (e.g. 4761234)">Product</label>
      </span>
      <span>
        <input type="radio" id="id_type_base_product_id" value="base_product_id" v-model="idType">
        <label for="id_type_base_product_id" title="Interpret as OKL Base Product Ids (e.g. 2621234)">Base Product</label>
      </span>
      <span>
        <input type="radio" id="id_type_upc_ean" value="upc_ean" v-model="idType">
        <label for="id_type_upc_ean" title="Interpret as UPC EANs (e.g. 797379041234)">UPC</label>
      </span>
      <span>
        <input type="radio" id="id_type_okl_sku" value="okl_sku" v-model="idType">
        <label for="id_type_okl_sku" title="Interpret as OKL SKUs (e.g. BRN1234)">OKL SKU</label>
      </span>
    </div>

    <template v-if="unrecognizedIds.length">
      No matches found for {{unrecognizedIds.length}} {{idTypeDisplay}}<Pluralize :count='unrecognizedIds.length'></Pluralize>:
      <div class="unrecognized-id">
        <span v-for="(id, index) in unrecognizedIds">
          {{id}}<span v-if="index < unrecognizedIds.length - 1">,</span>
        </span>
      </div>
    </template>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import _ from 'lodash';
import skuUtil from '@/util/sku';
import settingUtil from '@/util/setting';

const parseIdForType = (id, type) => {
  let value;
  if (['okl_sku'].includes(type)) {
    value = id;
  } else {
    value = parseInt(id, 10);
  }
  return value;
};

const validForType = (id, type) => {
  let valid = !!id;
  if (!['okl_sku'].includes(type)) {
    valid = valid && !isNaN(id);
  }
  return valid;
};

export default {
  name: 'selector',
  // TODO refactor unrecognizedIds to recognizedIds, logic should
  // be here in selector component and then can include ids that
  // are discarded as unparseable and never sent to api
  props: ['initialIds', 'initialType', 'unrecognizedIds'],
  data() {
    return {
      skuIdsRaw: '',
      idType: this.initialType || settingUtil.load('FLAG_SKUS.ID_TYPE') || 'bbb_sku_id',
    };
  },
  computed: {
    ...mapGetters(['selection']),
    selectionIds() {
      return this.selection.ids;
    },
    idTypeDisplay() {
      return skuUtil.labelForIdType(this.idType);
    },
  },
  watch: {
    skuIdsRaw() {
      this.updateValue(this.skuIdsRaw);
    },
    idType() {
      settingUtil.save('FLAG_SKUS.ID_TYPE', this.idType);
      this.updateSelectionType(this.idType);
      // determine valid selection ids in light of new type
      this.updateValue(this.skuIdsRaw);
    },
  },
  mounted() {
    if (this.initialIds) {
      this.skuIdsRaw = this.initialIds.join(' ');
    }

    this.updateSelectionType(this.idType);

    const textareaTags = this.$el.getElementsByTagName('textarea');
    if (textareaTags.length) {
      textareaTags[0].focus();
    }
  },
  methods: {
    updateValue(skuIdsRaw) {
      let skuIds = (skuIdsRaw && skuIdsRaw.split(/[,\s]+/)) || [];
      skuIds = _.uniq(skuIds)
        .filter(skuId => validForType(skuId, this.idType))
        .map(skuId => parseIdForType(skuId, this.idType))
        .sort((a, b) => a - b);

      this.updateSelectionIds(skuIds);
    },
    ...mapActions([
      'updateSelectionType',
      'updateSelectionIds',
    ]),
  },
};
</script>

<style lang="scss" scoped>
@import "~@/scss/global";

textarea {
  @include font-standard();
  border: none;
  outline: none;
  background-color: #f2faff;
  border-radius: 15px;
  width: 66%;
  padding: 20px;
  font-size: 16px;
  margin-top: 40px;
}

.unrecognized-id {
  color: darkred;
}

.id-type-toggle {
  margin-bottom: 25px;
  span {
    margin: 25px;
  }
}

</style>
