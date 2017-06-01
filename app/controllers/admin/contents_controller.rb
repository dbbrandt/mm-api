module Admin
  class ContentsController < Fae::BaseController
    before_action :set_interaction

    def index
      # :interaction set by AdminBaseController for index routes generated by fae after restful action
      if @interaction
        @items = Content.where(interaction_id: @interaction.id)
      else
        @items = Content.all
      end
    end

    private

    def build_assets
      @item.build_stimulus if @item.stimulus.blank?
    end

    def set_interaction
      cookies[:interaction_id] = params[:interaction_id] if params[:interaction_id]
      @interaction = Interaction.find_by_id(cookies[:interaction_id])
    end

  end
end
