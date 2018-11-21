<template>
  <span><a :href='kiboPdpUrl' target='_blank'>PDP</a></span>
</template>

<script>

export default {
  name: 'StorefrontLink',
  props: ['is_base_product', 'product_id', 'base_product_id'],
  computed: {
    kiboProductPrefix() {
      return this.is_base_product ? 'B' : 'P';
    },
    kiboProductId() {
      return this.is_base_product ? this.base_product_id : this.product_id;
    },
    kiboProductCode() {
      return this.kiboProductPrefix + this.kiboProductId;
    },
    kiboPdpUrl() {
      return `${this.storefrontUrl}/p/code/${this.kiboProductCode}.do`;
    },
    storefrontUrl() {
      return this.$store.getters.config('elysium', 'pdp_url');
    },
  },
};
</script>

