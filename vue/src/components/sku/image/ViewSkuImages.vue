<template>
  <div>
    <div v-if="isLoadingSkus">
      <Spinner msg='loading SKUs'/>
    </div>
    <div v-else>
      <SkuImagesTable :skus=skus></SkuImagesTable>
    </div>
  </div>
</template>

<script>
import _ from 'lodash';
import moment from 'moment';
import SkuImagesTable from '@/components/sku/image/SkuImagesTable';
import skuUtil from '@/util/sku';
import api from '@/api';

const DELAY_MS = 500;


export default {
  name: 'view-sku-images',
  components: {
    SkuImagesTable,
  },
  data() {
    return {
      skus: [],
      isLoadingSkus: false,
      idType: '',
      unrecognizedIds: [],

    };
  },
  computed: {
  },
  watch: {
    skuIds(skuIds) {
      if (skuIds) {
        this.loadSkusForIdsDebounced(skuIds);
      }
    },
    $route() {
      this.loadForRouteQuery();
    },
  },
  mounted() {
    this.loadForRouteQuery();
  },
  methods: {
    loadSkusForIdsDebounced: _.debounce(function go() { this.loadSkusForIds(); }, DELAY_MS),
    loadForRouteQuery() {
      let type;
      let id;
      const { query } = this.$route;
      skuUtil.idTypes.forEach((t) => {
        if (!type && query[t]) {
          type = t;
          id = query[t];
        }
      });
      if (type) {
        this.loadSkuImages(id, `${type}s`);
      }
    },
    loadSkuImages(id, type) {
      this.isLoadingSkus = true;
      api.skuImage.find(id, type)
        .then(({ skus }) => {
          skus.forEach((sku) => {
            sku.created_date = moment(sku.created_date).toDate();
            sku.modified_date = moment(sku.modified_date).toDate();
          });
          this.skus = skus;
        }).finally(() => {
          this.isLoadingSkus = false;
        });
    },
  },
};
</script>

<style lang="scss" scoped>
@import "~@/scss/global";

h1, h2 {
  font-weight: normal;
}

textarea {
  @include font-standard();
  border: none;
  outline: none;
  background-color: #f2faff;
  border-radius: 15px;
  width: 66%;
  height: 50px;
  padding: 20px;
  font-size: 16px;
  margin-top: 60px;
}

.unrecognized-id {
  color: darkred;
}

.btn {
  border: 0;
  background: $color-text;
  background-image: -webkit-linear-gradient(top, $color-blue, $color-blue-dark);
  background-image: -moz-linear-gradient(top, $color-blue, $color-blue-dark);
  background-image: -ms-linear-gradient(top, $color-blue, $color-blue-dark);
  background-image: -o-linear-gradient(top, $color-blue, $color-blue-dark);
  background-image: linear-gradient(to bottom, $color-blue, $color-blue-dark);
  color: #ffffff;
  font-size: 16px;
  padding: 10px 20px;
  text-decoration: none;
  cursor: pointer;
  margin-bottom: 15px;
}

.btn:hover {
  background: $color-blue-light;
  background-image: -webkit-linear-gradient(top, $color-blue-light, $color-blue);
  background-image: -moz-linear-gradient(top, $color-blue-light, $color-blue);
  background-image: -ms-linear-gradient(top, $color-blue-light, $color-blue);
  background-image: -o-linear-gradient(top, $color-blue-light, $color-blue);
  background-image: linear-gradient(to bottom, $color-blue-light, $color-blue);
  text-decoration: none;
}

.id-type-toggle {
  margin-bottom: 25px;
  span {
    margin: 25px;
  }
}

</style>
