module Admin
  class GoalsController < Fae::BaseController

    def interactions
      @items = Interaction.where(goal_id: params[:id])
      @goal = @item.goal
    end

    private

    def build_assets
      @item.build_hero_image if @item.hero_image.blank?
    end

  end
end
