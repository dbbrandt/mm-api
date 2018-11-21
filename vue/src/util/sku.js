const idTypeToLabel = {
  bbb_sku_id: 'BBB SKU ID',
  sku_id: 'OKL SKU ID',
  product_id: 'Product ID',
  base_product_id: 'Base Product ID',
  upc_ean: 'UPC EAN',
  okl_sku: 'OKL SKU',
};

export default {
  labelForIdType: idType => idTypeToLabel[idType] || 'unknown identifier',
  idTypes: Object.keys(idTypeToLabel),
};
