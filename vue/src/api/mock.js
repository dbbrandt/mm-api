import faker from 'faker';
import flags from '@/util/flag';

const DELAY_MS = 500;
const FLAGS = flags.enum;

export default {
  bootstrap() {
    return new Promise((resolve) => {
      const response = {
        king_parameters: [
          {
            application: 'KIBO',
            key: 'STOREFRONT_URL',
            value: 'http://avenidadereyes.com',
          },
        ],
      };
      setTimeout(() => resolve(response), DELAY_MS);
    });
  },
  skuChangeFlag: {
    find(ids) {
      return new Promise((resolve) => {
        const skuChangeFlags = ids.map(id => ({
          sku_id: id,
          bbb_sku_id: id,
          product_id: id,
          base_product_id: id,
          name: faker.commerce.productName(),
          created: faker.date.past(),
          modified: faker.date.recent(),
          item_master: faker.random.boolean(),
          fulfillment: faker.random.boolean(),
          storefront: faker.random.boolean(),
          storefront_delete: faker.random.boolean(),
          vmf_inventory: faker.random.boolean(),
          pricing: faker.random.boolean(),
          storefront_inventory: faker.random.boolean(),
          item_master_timestamp: faker.date.past(),
          fulfillment_timestamp: faker.date.past(),
          storefront_timestamp: faker.date.past(),
          storefront_delete_timestamp: faker.date.past(),
          vmf_inventory_timestamp: faker.date.past(),
          pricing_timestamp: faker.date.past(),
          storefront_inventory_timestamp: faker.date.past(),
          is_base_product_storefront_ready: faker.random.boolean(),
          selected: {
            item_master: false,
            fulfillment: false,
            storefront: false,
            vmf_inventory: false,
            pricing: false,
            storefront_inventory: false,
          },
        }));
        setTimeout(() => resolve({ sku_change_flags: skuChangeFlags }), DELAY_MS);
      });
    },
    update(skus) {
      skus.forEach((sku) => {
        const { selected } = sku;
        if (selected) {
          Object.keys(selected).forEach((key) => {
            if (selected[key] && FLAGS[key]) {
              selected[key] = false;
              sku[key] = true;
              sku[`${key}_timestamp`] = new Date();
            }
          });
        }
      });
      return new Promise((resolve) => {
        setTimeout(() => resolve(), DELAY_MS);
      });
    },
  },
  skuImage: {
    find(id) {
      return new Promise((resolve) => {
        const skuImages = [{
          sku_id: id,
          bbb_sku_id: id,
          product_id: id,
          base_product_id: id,
          name: faker.commerce.productName(),
          created: faker.date.past(),
          modified: faker.date.recent(),
          images: ['https://okl.scene7.com/is/image/OKL/Product_RLA11360_Image_1'],
        }];
        setTimeout(() => resolve({ skus: skuImages }), DELAY_MS);
      });
    },
  },
};
