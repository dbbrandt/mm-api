class InteractionsController < ApplicationController
  before_action :set_goal
  before_action :set_goal_interaction, only: [:show, :update, :destroy]

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
    params.permit(:name, :answer_type)
  end

  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def set_goal_interaction
    @interaction = @goal.interactions.select {|i|  i[:id] = params[:id]}  if @goal
  end
end