<template>
  <div v-if="isLoading">
    <Spinner msg='loading Interaction'/>
  </div>
  <div v-else>
    <template v-if="interactions">
      <div style="float: right;">
      as of <DateTime :value='loadTime' :timeIfToday='true'/>
        <v-btn flat v-on:click="loadInteractions">refresh</v-btn>
        <v-text-field :full-width=false v-model="max_interactions" label="Questions" placeholder="questions?" outline/>
      </div>
      <div style="float: left;">
        {{interactions.length}} Interaction<Pluralize :count='interactions.length'></Pluralize> (
        Correct: {{ correct }} / {{ percent }}% )
      </div>
      <div class="form">
        <img :src="image_url" class="stimulus_img">
        <div v-if="prompt">
          <v-btn flat v-on:click="showTitle">Show</v-btn>
          <div v-if="show_title">
            <div>
              {{prompt.title}}
            </div>
            <div>
              <v-btn flat small v-on:click="correctNext">Correct</v-btn>
              <v-btn flat small v-on:click="nextInteraction">Nope</v-btn>
              <v-btn flat small v-on:click="nextInteraction">Skip</v-btn>
            </div>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script>
  import api from '@/api';

  export default {
    name: 'interactions',
    data() {
      return {
        max_interactions: 4,
        interactions: null,
        isLoading: false,
        show_title: false,
        loadTime: null,
        position: 0,
        correct: 0,
      };
    },
    mounted() {
      this.loadInteractions();
    },
    computed: {
      prompt() {
        return this.interactions[this.position].prompt;
      },
      image_url() {
        return this.prompt.stimulus_url;
      },
      percent() {
        return (this.position > 0) ? 100 * (this.correct / this.position) : 0;
      },
      done() {
        return this.position >= this.max_interactions - 1;
      },
    },
    methods: {
      resetPosition() {
        this.position = 0;
        this.correct = 0;
        this.show_title = false;
      },
      loadInteractions() {
        this.isLoading = true;
        this.resetPosition();
        api.interactions.index(this.max_interactions)
          .then((response) => {
            this.interactions = response;
            this.loadTime = new Date();
            this.show_title = false;
          }).finally(() => {
            this.isLoading = false;
          });
      },
      correctNext() {
        this.correct += 1;
        this.nextInteraction();
      },
      nextInteraction() {
        this.show_title = false;
        if (this.done) {
          this.position += 1;
          alert(`Completed. Correct: ${this.correct} Result: ${this.percent}%`);
          this.resetPosition();
        } else {
          this.position += 1;
        }
      },
      showTitle() {
        this.show_title = true;
      },
    },
  };
</script>

<style lang="scss" scoped>

  .form {
    // padding-top: 20px;
    width: 100%;
    overflow: hidden;
    background-color: white;
  }

  .stimulus_img {
    padding-top: 20px;
    height: 300px;
  }

  .title {
    h-align: center;
  }
</style>
