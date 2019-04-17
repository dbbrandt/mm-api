<template>
  <div v-if="isLoading">
    <Spinner msg='loading Interaction'/>
  </div>
  <div v-else>
    <template v-if="interactions">
      <div class="refresh-form">
        as of <DateTime :value='loadTime' :timeIfToday='true'/>
        <v-btn flat v-on:click="loadInteractions" class="refresh-btn">refresh</v-btn>
        <v-text-field :full-width=false v-model="max_interactions" label="Questions" placeholder="questions?" outline />
        Interactions Answered: {{position}} / Correct: {{ correct_answers }} / {{ percent }}%
      </div>
      <div class="form">
        <div v-if="image_url">
          <img :src="image_url" class="stimulus_img">
        </div>
        <div v-else class="prompt">
          {{prompt_copy}}
        </div>
        <div class="response">
          <v-text-field :full-width=false v-model="answer" label="Answer" placeholder="Answer?" outline/>
        </div>
        <div v-if="correct_answer">
          <div class="show-button">
            <v-btn v-on:click="showTitle" class="vbutton">Show</v-btn>
          </div>
          <div v-if="show_title">
            <div class="answer">
              {{correct_answer}} - {{correct_text}} ({{ score }})
            </div>
            <div>
              <v-btn v-on:click="correctNext" class="vbutton">Correct</v-btn>
              <v-btn v-on:click="nextInteraction" class="vbutton">Nope</v-btn>
              <v-btn v-on:click="nextInteraction" class="vbutton">Skip</v-btn>
            </div>
            <div class="copy">
              {{copy}}
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
        max_interactions: 50,
        interactions: null,
        isLoading: false,
        show_title: false,
        loadTime: null,
        correct_answers: 0,
        position: 0,
        goal: null,
        answer: '',
        correct: '',
        result: null,
      };
    },
    mounted() {
      this.goal = this.$route.params.id;
      this.loadInteractions(this.goal);
    },
    computed: {
      total() {
        return this.interactions.length;
      },
      interaction() {
        return this.interactions[this.position];
      },
      interaction_id() {
        return this.interaction.id;
      },
      image_url() {
        return this.interaction.prompt.stimulus_url;
      },
      prompt_copy() {
        return this.interaction.prompt.copy;
      },
      correct_answer() {
        return this.interaction.criterion[0].descriptor;
      },
      copy() {
        return this.interaction.criterion[0].copy;
      },
      percent() {
        return (this.position > 0) ? 100 * (this.correct_answers / this.position) : 0;
      },
      done() {
        return this.position >= this.total - 1;
      },
      score() {
        return this.result ? this.result.score : 0;
      },
      correct_text() {
        if (this.result) {
          this.correct = this.result.correct ? 'Correct!' : 'Incorrect.';
        } else {
          this.correct = 'Unavailable..';
        }
        return this.correct;
      },
    },
    methods: {
      resetPosition() {
        this.position = 0;
        this.correct_answers = 0;
        this.show_title = false;
      },
      loadInteractions() {
        this.isLoading = true;
        this.resetPosition();
        api.interactions.index(this.goal, this.max_interactions)
          .then((response) => {
            this.interactions = response;
            this.loadTime = new Date();
            this.show_title = false;
          }).finally(() => {
            this.isLoading = false;
          });
      },
      correctNext() {
        this.correct_answers += 1;
        this.nextInteraction();
      },
      nextInteraction() {
        this.show_title = false;
        this.answer = '';
        this.response = '';
        if (this.done) {
          this.position += 1;
          alert(`Completed. Correct: ${this.correct_answers} Result: ${this.percent}%`);
          this.resetPosition();
        } else {
          this.position += 1;
        }
      },
      checkInteraction() {
        this.isLoading = true;
        api.interactions.check(this.goal, this.interaction_id, this.answer)
          .then((response) => {
            this.result = response;
          }).finally(() => {
            this.isLoading = false;
          });
      },
      showTitle() {
        this.checkInteraction();
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

  .response {
    margin: auto;
    width: 33%;
  }

  .copy {
    text-align: left;
    width: 80%;
    padding: 20px;
    margin: 0 50px;
  }

  .show-button  {
    width: 100%;
  }

  .refresh-form {
    float: right;
    text-align: right;
    margin-right: 20px;
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
  }

  .title {
    h-align: center;
  }

</style>
