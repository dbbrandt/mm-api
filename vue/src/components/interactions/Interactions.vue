<template>
  <div v-if="isLoading">
    <Spinner msg='loading Interaction'/>
  </div>
  <div v-else>
    <template v-if="interactions">
<<<<<<< HEAD
      <div class="refresh-form">
      as of <DateTime :value='loadTime' :timeIfToday='true'/>
        <v-btn flat v-on:click="loadInteractions" class="refresh-btn">refresh</v-btn>
        <v-text-field :full-width=false v-model="max_interactions" label="Questions" placeholder="questions?" outline />
=======
      <div style="float: right;">
      as of <DateTime :value='loadTime' :timeIfToday='true'/>
        <v-btn flat v-on:click="loadInteractions">refresh</v-btn>
        <v-text-field :full-width=false v-model="max_interactions" label="Questions" placeholder="questions?" outline/>
      </div>
      <div style="float: left;">
>>>>>>> Initial Vue Commit with Build
        {{interactions.length}} Interaction<Pluralize :count='interactions.length'></Pluralize> (
        Correct: {{ correct }} / {{ percent }}% )
      </div>
      <div class="form">
<<<<<<< HEAD
        <div v-if="image_url">
          <img :src="image_url" class="stimulus_img">
        </div>
        <div v-else class="prompt">
          {{copy}}
          <v-text-field :full-width=false v-model="response" label="Answer" placeholder="Answer?" outline />
        </div>
        <div v-if="answer">
          <v-btn v-on:click="showTitle" class="vbutton">Show</v-btn>
          <div v-if="show_title">
            <div class="answer">
              {{answer}}
            </div>
            <div>
              <v-btn v-on:click="correctNext" class="vbutton">Correct</v-btn>
              <v-btn v-on:click="nextInteraction" class="vbutton">Nope</v-btn>
              <v-btn v-on:click="nextInteraction" class="vbutton">Skip</v-btn>
=======
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
>>>>>>> Initial Vue Commit with Build
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
<<<<<<< HEAD
        max_interactions: 50,
=======
        max_interactions: 4,
>>>>>>> Initial Vue Commit with Build
        interactions: null,
        isLoading: false,
        show_title: false,
        loadTime: null,
        position: 0,
        correct: 0,
<<<<<<< HEAD
        goal: null,
        reponse: '',
      };
    },
    mounted() {
      this.goal = this.$route.params.id;
      this.loadInteractions(this.goal);
    },
    computed: {
      interaction() {
        return this.interactions[this.position];
      },
      image_url() {
        return this.interaction.prompt.stimulus_url;
      },
      copy() {
        return this.interaction.prompt.copy;
      },
      answer() {
        return this.interaction.criterion[0].descriptor;
=======
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
>>>>>>> Initial Vue Commit with Build
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
<<<<<<< HEAD
        api.interactions.index(this.goal, this.max_interactions)
=======
        api.interactions.index(this.max_interactions)
>>>>>>> Initial Vue Commit with Build
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
<<<<<<< HEAD
        this.response = '';
=======
>>>>>>> Initial Vue Commit with Build
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
<<<<<<< HEAD
    padding-top: 40px;
    width: 300px;
  }
  .prompt {
    font-size: 30px;
    padding: 40px;
  }

  .answer {
    font-size: 20px;
    padding: 20px;
  }

  .refresh-form {
    float: right;
    text-align: right;
  }

  .input-group--text-field .input {
    font-size: 50px;
  }

  @media only screen
    and (min-device-width : 375px)
    and (max-device-width : 812px)
    and (-webkit-device-pixel-ratio : 3) {
    .stimulus_img {
      padding-top: 20px;
      width: 50%;
    }
    .answer {
      font-size: 40px;
      padding: 20px;
    }

    .vbutton {
      height: 70px;
      font-size: 40px;
    }

    .refresh-btn {
      font-size: 30px;
    }

    .refresh-form {
      padding-top: 40px;
      float: left;
      text-align: left;
    }

    .input-group .input-group__input {
      font-size: 30px;
    }
=======
    padding-top: 20px;
    height: 300px;
>>>>>>> Initial Vue Commit with Build
  }

  .title {
    h-align: center;
  }
<<<<<<< HEAD

=======
>>>>>>> Initial Vue Commit with Build
</style>
