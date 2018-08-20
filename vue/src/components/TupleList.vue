<!--component to render lists of key/value pairs, including nested list values-->

<template>
  <table cellspacing="0">
    <template v-for="value, name in tuples">
      <tr v-if="isRelevant(name, value)" class="hover">
        <td class="u-align-left">
          <b>{{name}}</b>
        </td>
        <td class="u-align-right">
          <template v-if="isList(value)">
            <TupleList v-bind:tuples="value"/>
          </template>
          <template v-else-if="isTimestamp(value)">
            <DateTime :value="new Date(value)"/>
          </template>
          <template v-else>
            {{value}}
          </template>
        </td>
      </tr>
    </template>
  </table>
</template>

<script>
import TupleList from '@/components/TupleList';
import DateTime from '@/components/DateTime';

export default {
  name: 'TupleList',
  props: ['tuples', 'shallow'],
  components: {
    TupleList,
    DateTime,
  },
  methods: {
    isTimestamp(value) {
      return /\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d.\d{3}-\d\d:\d\d/.test(value);
    },
    isList(value) {
      return typeof value === 'object' && value !== null;
    },
    isRelevant(name, value) {
      return name !== 'sku_id' && (!this.isList(value) || !this.shallow);
    },
  },
};
</script>

<style lang="scss">
  .hover:hover {
    background-color: #92c98d;
  }

  td {
    padding: 2px 5px;
  }
</style>
