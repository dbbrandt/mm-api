import Vue from 'vue';
import Router from 'vue-router';
import Goals from '@/components/goals/Goals';
import Interactions from '@/components/interactions/Interactions';
import AuxTools from '@/components/AuxTools';
import FlagSkus from '@/components/sku/flag/FlagSkus';
import ViewSkuImages from '@/components/sku/image/ViewSkuImages';
import PriceRequests from '@/components/sku/pca/PriceRequests';
import RosettaSku from '@/components/sku/ids/RosettaSku';
import ViewASku from '@/components/sku/ViewASku';

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/',
      redirect: { name: 'Goals' },
    },
    {
      path: '/goals',
      name: 'Goals',
      component: Goals,
    },
    {
<<<<<<< HEAD
      path: '/interactions/:id',
=======
      path: '/interactions',
>>>>>>> Initial Vue Commit with Build
      name: 'Interactions',
      component: Interactions,
    },
    {
      path: '/aux-tools',
      name: 'Aux Tools',
      component: AuxTools,
    },
    {
      path: '/flag-skus',
      name: 'Flag Skus',
      component: FlagSkus,
    },
    {
      path: '/view-sku-images',
      name: 'View Sku Images',
      component: ViewSkuImages,
    },
    {
      path: '/pca',
      name: 'Price and Cost Change Requests',
      component: PriceRequests,
    },
    {
      path: '/rosetta-sku',
      name: 'Rosetta SKU',
      component: RosettaSku,
    },
    {
      path: '/view-a-sku/:id',
      name: 'View-A-SKU',
      component: ViewASku,
    },
  ],
});
