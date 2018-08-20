<template>
  <div>
    View-A-Sku<br>
    <div v-if="isLoadingSku">
      <Spinner msg='loading SKU'/>
    </div>
    <div v-else-if="sku">
      <div class="row">
        <template v-if="parent_sku_id">
          <a v-on:click="loadSourceSku">Copy of: {{ parent_sku_id }}</a>
        </template>
      </div>
      <div class="row">
        <div class="column" v-if="show_duplicate_form">
          <form @submit.prevent="duplicateSku">
            <input align="left" type="Text" placeholder="brand_code (optional)" v-model="brand_code"/>
            <v-btn type="submit" onclick="return confirm('Are you sure?')">Duplicate</v-btn>
          </form>
        </div>
        <div class="column" v-else>
          <a v-on:click="toggleDuplicateForm">duplicate</a>
        </div>
      </div>
      <div class="row">
        <v-container fluid grid-list-md>
          <v-layout row wrap>

            <CardWithHeader>
              <template slot="header">images</template>
              <div slot>
                <img :src="sku.primary_image" title="primary image" class="primary-image">
                <span v-for="image in sku.all_images">
                  <img v-if="image != sku.primary_image" :src="image" class="image"><br/>
                </span>
              </div>
            </CardWithHeader>

            <CardWithHeader v-for="fieldset in fieldsets" >
              <template slot="header">{{fieldset.name}}</template>
              <div slot>
                <template v-if="fieldset.name == 'sku'">
                  <TupleList v-bind:tuples=sku :shallow=true></TupleList>
                </template>
                <template v-else>
                  <TupleList v-bind:tuples=sku[fieldset.name]></TupleList>
                </template>
              </div>
            </CardWithHeader>

          </v-layout>
        </v-container>
      </div>
    </div>
    <div v-else>
      No SKU Loaded.
    </div>
  </div>
</template>

<script>
import api from '@/api';
import TupleList from '@/components/TupleList';
import CardWithHeader from '@/components/CardWithHeader';

const FIELDSETS = {
  sku: [
    'sku_id',
    'bbb_sku_id',
    'upc_ean',
    'okl_sku',
    'product_id',
    'base_product_id',
    'vendor_sku',
    'is_vintage',
    'unit_of_measure',
    'price',
    'pre_markdown_price',
    'cost',
    'wholesale',
    'retail',
    'is_deleted',
    'is_non_taxable',
    'is_vmf',
    'is_pre_buy',
    'is_active',
    'is_auto_clearance',
  ],
  bbb_reference: null,
  vendor: null,
  brand: null,
  inventory_reservable: null,
  change_flags: null,
  sku_description: null,
  sku_settings: null,
  sku_states: null,
  line_of_business: null,
  base_product: null,
  product: null,
  sku_dimensions: null,
  current_price_and_cost_change_requests: null,
  sku_attribute_values: null,
  sku_shipping: null,
  sku_parent: null,
};

export default {
  name: 'view-a-sku',
  components: {
    TupleList,
    CardWithHeader,
  },
  data() {
    return {
      sku: null,
      isLoadingSku: false,
      brand_code: '',
      parent_sku_id: '',
      show_duplicate_form: false,
    };
  },
  mounted() {
    this.loadForRouteQuery();
  },
  computed: {
    fieldsets() {
      // convert concise constant object into an array with fields `name` and `fields`
      return Object.keys(FIELDSETS).map(name => ({
        name,
        fields: FIELDSETS[name],
      }));
    },
  },
  methods: {
    loadForRouteQuery() {
      this.loadSku(this.$route.params.id);
    },
    loadSku(id) {
      this.isLoadingSku = true;
      api.sku.findFat(id, 'sku_id', true)
        .then((response) => {
          this.sku = response;
          this.parent_sku_id = response.sku_parent && response.sku_parent.parent_sku_id;
          this.show_duplicate_form = false;
        }).finally(() => {
          this.isLoadingSku = false;
        });
    },
    loadSourceSku() {
      this.loadSku(this.parent_sku_id);
      this.$router.push({ name: 'View-A-SKU', params: { id: this.parent_sku_id } });
    },
    toggleDuplicateForm() {
      this.show_duplicate_form = true;
    },
    duplicateSku() {
      this.isLoadingSku = true;
      api.sku.duplicate(this.sku.sku_id, this.brand_code)
        .then((response) => {
          if (response) {
            this.sku = response;
            this.parent_sku_id = response.sku_parent && response.sku_parent.parent_sku_id;
            this.show_duplicate_form = false;
            this.$router.push({ name: 'View-A-SKU', params: { id: this.sku.sku_id } });
          }
        }).finally(() => {
          this.isLoadingSku = false;
        });
    },
  },
};
</script>

<style lang="scss" scoped>
  @import "~@/scss/global";

  fieldset {
    width: 45%;
    display: inline-block;
  }
  ul {
    display: inline-block;
  }
  .image {
    border: 1px solid grey;
  }
  .primary-image {
    border: 1px solid black;
  }
  input {
    border: 1px solid #90a4ae;
    padding-left: 5px;
  }
  .row {
    width: 100%;
  }
  .column {
    width: 50%;
    float: right;
  }

</style>
