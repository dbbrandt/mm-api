<template>
  <div v-if="isLoading">
    <Spinner msg='loading Interaction'/>
  </div>
  <div v-else>
    <template v-if="interactions">
      <div class="refresh-form">
        <div>as of <DateTime :value='loadTime' :timeIfToday='true'/></div>
        <div class="refresh">
        <v-btn flat v-on:click="loadInteractions" class="refresh-btn">refresh</v-btn>
        </div>
        <div>
          <div  class="questions">
            Questions:
          </div>
          <div class="question_input">
            <input align="left" type="Text" placeholder="Questions" v-model="max_interactions" class="questions_text"/>
          </div>
        </div>
        <div class="questions">
          Interactions Answered: {{score_count}}
        </div>
        <div>
          Correct: {{ correct_answers }} / {{ percent }}%
        </div>
        <div>
          Score: {{ total_score }}%
        </div>
      </div>
      <div class="form">
        <div v-if="image_url">
          <img :src="image_url" class="stimulus_img">
        </div>
        <div v-else class="prompt">
          {{prompt_copy}}
        </div>
        <div class="response">
          <input align="left" type="Text" placeholder="answer..." v-model="answer" class="response_text" v-on:keydown.enter="showTitle" ref="answer" v-focus/>
        </div>
        <div v-if="correct_answer">
          <div class="show-button">
            <v-btn v-on:click="showTitle" class="vbutton">Show</v-btn>
          </div>
          <div v-if="show_title">
            <div v-if="isLoadingAnswer">
              <Spinner msg='Checking Answer'/>
            </div>
            <div v-else>
              <div class="answer">
                {{correct_answer}} - {{correct_text}} ({{ score }})
              </div>
              <div>
                <v-btn v-on:click="correctNext" class="vbutton" ref="correct">Correct</v-btn>
                <v-btn v-on:click="nextInteraction" class="vbutton" ref="incorrect">Nope</v-btn>
                <v-btn v-on:click="nextInteraction" class="vbutton">Skip</v-btn>
              </div>
              <div class="copy">
                {{copy}}
              </div>
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
        isLoadingAnswer: false,
        loadTime: null,
        correctThreshold: 0.85,
        correct_answers: 0,
        aggregate_score: 0,
        score_count: 0,
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
        return (this.position > 0) ? Math.round(100 * (this.correct_answers / this.score_count)) : 0;
      },
      done() {
        return this.position >= this.total;
      },
      score() {
        return this.result ? Math.round(this.result.score * 100) : 0;
      },
      total_score() {
        const totalScore = Math.round(this.aggregate_score / this.score_count);
        return this.score_count > 0 ? totalScore : 0;
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
        this.aggregate_score = 0;
        this.score_count = 0;
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
        this.position += 1;
        // this.$refs.answer.focus();
        if (this.done) {
          alert(`Completed. Correct: ${this.correct_answers} Result: ${this.percent}% Score = ${this.total_score}`);
          this.resetPosition();
        }
      },
      checkInteraction() {
        // this.isLoadingAnswer = true;
        api.interactions.check(this.goal, this.interaction_id, this.answer)
          .then((response) => {
            this.result = response;
            this.aggregate_score += this.score;
            this.score_count += 1;
          }).finally(() => {
            this.isLoadingAnswer = false;
            this.$nextTick(() => {
              if (this.score >= this.correctThreshold) {
                this.$refs.correct.$el.focus();
              } else {
                this.$refs.incorrect.$el.focus();
              }
            });
          });
      },
      showTitle() {
        if (!this.show_title) {
          this.checkInteraction();
          this.show_title = true;
        }
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

  .questions {
    float: left;
  }

  .question_input input {
    width: 30px;
    border: 1px solid #b1b1b1;
    padding-left: 5px;
  }

  .question_text {
    font-size: 20px;
  }

  .response_text {
    font-size: 20px;
    padding-left: 5px;
    border: 1px solid #b1b1b1;
  }

  .response {
    padding-top: 20px;
    padding-bottom: 20px;
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

  .refresh {
    height: 35px;
  }

  .refresh-btn {
    text-align: left;
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

    .refresh {
      height: 35px;
      padding-bottom: 60px;
    }

    .refresh-form {
      padding-top: 40px;
      float: left;
      text-align: left;
    }

    .question_text {
      font-size: 40px;
    }

    .response_text {
      font-size: 40px;
    }

    .input-group .input-group__input {
      font-size: 30px;
    }
  }

  .title {
    h-align: center;
  }

</style>
