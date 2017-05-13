module Admin
  class GoalsController < FaeBaseController

    private

    def build_assets
      @item.build_hero_image if @item.hero_image.blank?
    end

  end
end
