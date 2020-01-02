module Api
  class InteractionsController < ApplicationController
    before_action :set_goal

    MMAPIPY_URL="http://www.memorymaestro.com/mm-api-py"

    # GET /goals/:goal_id/interactions
    def index
      type = params['type'] == 'mc' ? :multiple_choice : :short_answer
      result = @goal.interactions
      if params['deep']
        result = result.send(type).includes(:contents).map {|i| deep_response(i)}
        if params['deep'] == 'game'
          size = params['size'] ? (params['size'].to_i - 1)  : 49
          result = result.shuffle[0..size]
        end
      end
      json_response(result)
    end

    # GET /goals/:goal_id/interactions/:id
    def show
      json_response(params["deep"] ? deep_response(@interaction) : @interaction )
    end

    # POST /goals/:goal_id/interactions
    def create
      @interaction = @goal.interactions.create!(interaction_params)
      json_response(params["deep"] ? deep_response(@interaction) : @interaction, :ok)
    end

    # PUT /goals/:goal_id/interactions/:id
    def update
      save_contents if params['deep']
      @interaction.update(interaction_params)
      json_response(params["deep"] ? deep_response(@interaction) : @interaction, :ok)
    end

    # DELETE /goals/:goal_id/interactions/:id
    def destroy
      @interaction.destroy
      head :no_content
    end

    # GET /goals/:goals_id/interactions/:id?answer=
    def check_answer
      answer = params['answer']
      correct_answer = @interaction.correct_answer
      correct, score = @interaction.check_answer(answer)

      params = "?answer=#{answer}&correct=#{correct_answer}"
      predicted = correct_answer
      if !answer.empty?
        response = HTTParty.get(MMAPIPY_URL+params)
        if response.code == 200
          logger.info("HTTP mm-api-py result: #{response.body}")
          results = JSON.parse(response.body)
          predicted = results['prediction']
          # Use the mm-api-py value unless it's overriden locally by a high score
          # We still want to see what the api returns
          correct = results['correct'] unless correct && @interaction.score_override?(score)
        else
          logger.error "check_answer: Https request faild with #{response.code} - #{response.body}"
        end
      end
      json_response({
         "correct": correct,
         "score": score,
         "predicted": predicted
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
      params.permit(:title, :answer_type, :prompt, :criterion)
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
        "created_at": i.created_at,
        "updated_at": i.updated_at,
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

    def save_contents
      prompt = @interaction.prompt
      if prompt
        new_p = params['prompt']
        prompt.title = new_p['title'].blank? ? params['title'] : new_p['title']
        prompt.copy = new_p['copy']
        #TODO support saving stimulus_url
        prompt.save
      end
      @interaction.criterion.each_with_index {|criterion, i|
        if criterion
          new_c = params['criterion'][i]
          criterion.title = new_c['title'].blank? ? params['title'] : new_c['title']
          criterion.copy = new_c['copy']
          criterion.description = new_c['description']
          criterion.descriptor = new_c['descriptor']
          criterion.save
        end
      }
    end
  end
end
