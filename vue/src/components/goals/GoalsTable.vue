<template>
  <table>
    <thead>
    <tr>
      <th>Title</th>
      <th>Description</th>
      <th>Instructions</th>
      <th>Created</th>
      <th>Modified</th>
    </tr>
    </thead>
    <tbody>
    <tr v-for="goal in goals">
<<<<<<< HEAD
      <td class="u-align-left"><router-link :to="{ path: `interactions/${goal.id}`}">{{goal.title}}</router-link></td>
=======
      <td class="u-align-left"><router-link :to="{ path: 'interaction', query: { goal_id: goal.goal_id }}">{{goal.title}}</router-link></td>
>>>>>>> Initial Vue Commit with Build
      <td class="u-align-left">{{goal.description}}</td>
      <td class="u-align-left">{{goal.instructions}}</td>
      <td><DateTime :value='goal.created_at'></DateTime></td>
      <td><DateTime :value='goal.updated_at'></DateTime></td>
    </tr>
    </tbody>
  </table>
</template>


<script>
    export default {
      name: 'GoalsTable',
      props: ['goals'],
    };
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>
  @import "~@/scss/global";

  a {
    color: #2980b9;
  }

  table {
    width: 100%;
    overflow: hidden;
    background-color: white;
  }

  td, th {
    position: relative;
  }

  table tr:nth-child(odd) td{
    background-color: #f2faff;
  }

</style>

