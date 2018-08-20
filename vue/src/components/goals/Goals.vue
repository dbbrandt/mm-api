<template>
  <div v-if="isLoadingGoals">
    <Spinner msg='loading SKUs'/>
  </div>
  <div v-else>
    <template v-if="goals.length">

      {{goals.length}} Goal<Pluralize :count='goals.length'></Pluralize>
      <div style="float: right">
        as of <DateTime :value='loadTime' :timeIfToday='true'/>
        <v-btn flat v-on:click="loadGoals">refresh</v-btn>
      </div>
      <GoalsTable :goals=goals></GoalsTable>
    </template>
  </div>
</template>

<script>
  import api from '@/api';
  import GoalsTable from '@/components/goals/GoalsTable';

  export default {
    name: 'goals',
    components: {
      GoalsTable,
    },
    data() {
      return {
        goals: [2, 3, 4],
        isLoadingGoals: false,
        loadTime: null,
      };
    },
    mounted() {
      this.loadGoals();
    },
    methods: {
      loadGoals() {
        this.isLoadingGoals = true;
        api.goals.index()
          .then((response) => {
            this.goals = response;
            this.loadTime = new Date();
          }).finally(() => {
            this.isLoadingGoals = false;
          });
      },
    },
  };
</script>

<style lang="scss" scoped>
  .menu-pane {
    padding-top: 200px;
    padding-left: 20px;
    margin: auto;
    width: 33%;
    text-align: left;
    font-size: 18px;
  }
</style>
