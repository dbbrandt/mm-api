<template>
  <div>
    <v-data-table
      v-bind:headers="headers"
      :items="priceRequests"
      hide-actions
      class="elevation-1"
    >
      <template slot="items" slot-scope="props">
        <template v-if="showSkuId">
          <td v-if="isPowerUser" class="text-xs-right">
            <router-link :to="{ path: 'view-sku-images', query: { sku_id: props.item.sku_id }}">{{props.item.sku_id}}</router-link>
          </td>
          <td class="text-xs-right">
            <router-link :to="{ path: 'view-sku-images', query: { bbb_sku_id: props.item.bbb_sku_id }}">{{props.item.bbb_sku_id}}</router-link>
          </td>
        </template>
        <td class="text-xs-right">{{props.item.id}}</td>
        <td class="text-xs-right"><DateTime :value='props.item.created_date'></DateTime></td>
        <td class="text-xs-center">
          {{ props.item.status }}
          <div v-if="props.item.reject_reason">
            {{ props.item.reject_reason }}
          </div>
          <v-btn flat
                 icon
                 color="pink"
                 v-if="canCancel(props.item.status)"
                 v-on:click="cancel(props.item.id)"
                 :loading="cancelling[props.item.id]"
                 title="Halt this request, skipping any previously scheduled price or cost changes or reversions"
          >
            <v-icon>cancel</v-icon>
          </v-btn>
        </td>
        <td class="text-xs-left">{{props.item.submitter.firstname}} {{ props.item.submitter.lastname }}</td>
        <td class="text-xs-left">{{ props.item.reason }}</td>
        <td class="text-xs-left">
          <template v-if="props.item.reviewer">
            {{props.item.reviewer.firstname}} {{ props.item.reviewer.lastname }}
          </template>
        </td>
        <td class="text-xs-right state-original">
          <template v-if="props.item.price">
            {{props.item.originalPrice || ('* ' + props.item.current_price)}}
          </template>
        </td>
        <td class="text-xs-right state-original">
          <template v-if="props.item.cost">
            {{props.item.originalCost || ('* ' + props.item.current_cost)}}
          </template>
        </td>
        <td class="text-xs-right state-change">
          <DateTime :value='props.item.change_datetime' :westCoast=true></DateTime>
        </td>
        <td class="text-xs-right state-change">
          <FutureChangeStatus :status='props.item.priceChangeStatus'/>
          {{props.item.price}}
        </td>
        <td class="text-xs-right state-change">
          <FutureChangeStatus :status='props.item.costChangeStatus'/>
          {{props.item.cost}}
        </td>
        <td class="text-xs-right state-revert">
          <DateTime :value='props.item.revert_datetime' :westCoast=true></DateTime>
        </td>
        <td class="text-xs-center state-revert">
          <FutureChangeStatus :status='props.item.priceRevertStatus'/>
        </td>
        <td class="text-xs-center state-revert">
          <FutureChangeStatus :status='props.item.costRevertStatus'/>
        </td>
      </template>
    </v-data-table>

    <table class="legend">
      <thead>
        <tr>
          <th colspan="2">Change and Revert Statuses</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Processed</td>
          <td><FutureChangeStatus status="processed"/></td>
        </tr>
        <tr>
          <td>Pending</td>
          <td><FutureChangeStatus status="pending"/></td>
        </tr>
        <tr>
          <td>Skipped</td>
          <td><FutureChangeStatus status="skipped"/></td>
        </tr>
        <tr>
          <td>Failed</td>
          <td>
            <FutureChangeStatus status="failed"/>
          </td>
        </tr>
      </tbody>
    </table>
    <div class="legend">* indicates current price or cost</div>
    <textarea class="debug">
      {{priceRequests}}
    </textarea>
  </div>
</template>

<script>
import Vue from 'vue';
import { mapGetters } from 'vuex';
import FutureChangeStatus from '@/components/sku/pca/FutureChangeStatus';
import api from '@/api';

const headers = [
  { align: 'right', text: 'SKU' },
  { align: 'right', text: 'BBB SKU' },
  { align: 'right', text: 'ID' },
  { align: 'right', text: 'Created' },
  { align: 'center', text: 'Status' },
  { align: 'left', text: 'Submitter' },
  { align: 'left', text: 'Reason' },
  { align: 'left', text: 'Reviewer' },
  { align: 'right', class: 'state-original', text: 'Price' },
  { align: 'right', class: 'state-original', text: 'Cost' },
  { align: 'right', class: 'state-change', text: 'Change' },
  { align: 'right', class: 'state-change', text: 'Price' },
  { align: 'right', class: 'state-change', text: 'Cost' },
  { align: 'right', class: 'state-revert', text: 'Revert' },
  { align: 'center', text: 'Price', class: 'state-revert' },
  { align: 'center', text: 'Cost', class: 'state-revert' },
];
headers.forEach((header) => {
  header.sortable = false;
});

export default {
  name: 'PriceRequestsTable',
  props: ['priceRequests', 'showSkuId'],
  components: {
    FutureChangeStatus,
  },
  computed: {
    ...mapGetters([
      'isPowerUser',
    ]),
    headers() {
      // show sku id only when showing more than one sku
      return headers.filter((header, index) => {
        // columns after the second are always shown
        let showHeader;
        if (index > 1) {
          showHeader = true;
        } else if (this.showSkuId) {
          // show bbb sku id but sku id only if power user
          showHeader = index === 1 || this.isPowerUser;
        }
        return showHeader;
      });
    },
  },
  data() {
    return {
      // map of is cancelling in progress by pccr id
      cancelling: {},
    };
  },
  methods: {
    canCancel: status => ['approved', 'in progress'].includes(status),
    cancel(id) {
      Vue.set(this.cancelling, id, true);
      api.priceAndCostChangeRequests.cancel(id).then((priceAndCostChangeRequest) => {
        this.$emit('refreshItem', priceAndCostChangeRequest);
      }, (error) => {
        // TODO safe navigation, perhaps with babel plugin
        // https://github.com/vuejs/vue/issues/4638
        const message = (error && error.response && error.response.data && error.response.data.message) || '';
        // TODO material design alert
        alert(`Failed to Cancel Price and Cost Change Request\n${message}`);
      }).finally(() => {
        Vue.set(this.cancelling, id, false);
      });
    },
  },
};
</script>

<style lang="scss">
  .state-original {
  }
  .state-change {
    background-color: rgba(250, 250, 210, 0.59);
  }
  .state-revert {
  }
  textarea.debug {
    height: 600px;
    width: 100%;
    font-size: 10px;
    float: right;
    display: none;
  }
  .legend {
    float: right;
    margin-left: 25px;
  }
</style>
