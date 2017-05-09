class InteractionsController < ApplicationController
  before_action :set_goal
  before_action :set_goal_interaction, only: [:show, :update, :destroy]

  # GET /interactions/:interaction_id/contents
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
    @goal.update(interaction_params)
    head :no_content
  end

  # DELETE /goals/:goal_id/interactions/:id
  def destroy
    @interaction.destroy
    head :no_content
  end

  private

  def interaction_params
    params.permit(:type, :description, :image_url, :copy, :score, :descriptor)
  end

  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def set_goal_interaction
    @interaction = @goal.interactions.find_by!(id: params[:id]) if @goal
  end

end
