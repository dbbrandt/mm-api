module Admin
  class InteractionsController < Fae::BaseController

    def show
      @items = Goal.find_by_id(params[:goal_id]).interactions
      render :index
    end
  end
end
