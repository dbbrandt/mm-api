module Api
  class GoalsController < ApplicationController
    before_action :set_goal, only: [:show, :update, :destroy, :purge]

    # GET /goals
    def index
      @goals = Goal.all
      json_response(@goals)
    end

    # POST /goals
    def create
      @goal = Goal.create!(goal_params)
      json_response(@goal, :created)
    end

    # GET /goals/:id
    def show
      json_response(@goal)
    end

    # PUT /goals/:id
    def update
      @goal.update(goal_params)
      json_response(@goal, :ok)
    end

    # DELETE /goals/:id
    def destroy
      @goal.destroy
      head :no_content
    end

    # Delete /goals/:id/purge
    def purge
      @goal.interactions.destroy_all
      head :no_content
    end


    private

    def goal_params
      # whitelist params
      params.permit(:title,  :description, :instructions)
    end

    def set_goal
      @goal = Goal.preload(:interactions, :contents).find(params[:id])
    end
  end
end
