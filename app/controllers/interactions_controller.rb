class InteractionsController < ApplicationController
  before_action :set_goal

  # GET /goals/:goal_id/interactions
  def index
    json_response(@goal.interactions)
  end

  # GET /goals/:goal_id/interactions/:id
  def show
    json_response(@interaction)
  end

  # POST /goals/:goal_id/interactions
  def create
    @goal.interactions.create!(interaction_params)
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

  #
  private

  def interaction_params
    params.permit(:title, :answer_type)
  end

  def set_goal
    # require the goal context for all interaction requests
    return unless params[:goal_id]
    @goal = Goal.preload(:interactions).find(params[:goal_id])
    @interaction = Interaction.preload(:contents).find(params[:id]) if params[:id]
  end

end