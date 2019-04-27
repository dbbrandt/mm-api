module Api
  class InteractionsController < ApplicationController
    before_action :set_goal

    # GET /goals/:goal_id/interactions
    def index
      if params["deep"]
        size = params["size"] ? (params["size"].to_i - 1)  : 49
        type = params["type"] == 'mc' ? :multiple_choice : :short_answer
        json_response(@goal.interactions.send(type).includes(:contents).map {|i| deep_response(i)}.shuffle[0..size])
      else
        json_response(@goal.interactions)
      end
    end

    # GET /goals/:goal_id/interactions/:id
    def show
      json_response(params["deep"] ? deep_response(@interaction) : @interaction )
    end

    # POST /goals/:goal_id/interactions
    def create
      @interaction = @goal.interactions.create!(interaction_params)
      json_response(@interaction, :created)
    end

    # PUT /goals/:goal_id/interactions/:id
    def update
      @interaction.update(interaction_params)
      head :no_content
    end

    # DELETE /goals/:goal_id/interactions/:id
    def destroy
      @interaction.destroy
      head :no_content
    end

    # GET /goals/:goals_id/interactions/:id?answer=
    def check_answer
      correct, score = @interaction.check_answer(params['answer'])
      json_response({
         "correct": correct,
         "score": score
      })
    end

    def submit_review
      response = save_response(params['answer'], params['score'], params['correct'], params['review'])
      json_response({
          "round": @round.id,
          "response": response.id
      })
    end

    private

    def interaction_params
      params.permit(:title, :answer_type)
    end

    def set_goal
      # require the goal context for all interaction requests
      return unless params[:goal_id]
      @goal = Goal.preload(:interactions).find(params[:goal_id])
      @interaction = Interaction.preload(:contents).find(params[:id]) if params[:id]
      set_round if params['round']
    end

    def set_round
      user = Fae::User.first
      if params['round']
        round_id = params['round'].to_i
        @round = Round.where(id: round_id).first
        @round = Round.create(goal: @goal, fae_user_id: user.id) unless @round
      end
    end

    def save_response(answer, score, is_correct, review_is_correct)
      RoundResponse.create(round: @round, interaction: @interaction, answer: answer, score: score,
                                      is_correct: is_correct, review_is_correct: review_is_correct)
    end

    def deep_response(interaction)
       i = interaction
       p = interaction.prompt
      {
        "id": i.id,
        "title": i.title,
        "answer_type": i.answer_type,
        "prompt": {
          "title": p&.title,
          "copy": p&.copy,
          "stimulus_url": i.stimulus_url
        },
        "criterion": criterion_response(interaction)
      }
    end

    def criterion_response(interaction)
      resp = []
      interaction.criterion.each do |c|
        resp << { "title": c.title,
                      "description": c.description,
                      "copy": c.copy,
                      "descriptor": c.descriptor,
                      "score": c.score
                    }
      end
      resp
    end
  end
end