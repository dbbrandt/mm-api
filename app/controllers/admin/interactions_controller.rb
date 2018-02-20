module Admin
  class InteractionsController < Fae::BaseController
    before_action :set_goal

    def index
      if @goal
        @items = Interaction.where(goal_id: @goal.id)
      else
        @items = Interaction.all
      end
    end

    private

    def set_goal
      cookies[:goal_id] = params[:goal_id] if params[:goal_id]
      @goal = Goal.find_by_id(cookies[:goal_id])
    end

  end
end
