module Admin
  class ContentsController < Fae::BaseController

    private

    def build_assets
      @item.build_stimulus if @item.stimulus.blank?
    end

  end
end
