module Admin
  class ContentsController < FaeBaseController

    def index
      if params[:interaction_id]
        @interaction = Interaction.find_by_id(params[:interaction_id])
        @items = Content.where(interaction_id: @interaction.id)
      else
        @items = Content.all
      end
    end

    def new
      @interaction = Interaction.find_by_id(params[:interaction_id])
      super
    end

    def create_old
      return create_from_existing(params[:from_existing]) if params[:from_existing].present?

      @item = @klass.new(item_params)

      if @item.save
        #redirect_to @index_path, notice: t('fae.save_notice')
        redirect_to admin_interaction_contents_path(interaction_id: @item.interaction_id), notice: t('fae.save_notice')
      else
        build_assets
        flash[:alert] = t('fae.save_error')
        render action: 'new'
      end
    end

    def update_old
      if @item.update(item_params)
        redirect_to admin_interaction_contents_path(interaction_id: @item.interaction_id), notice: t('fae.save_notice')
      else
        build_assets
        flash[:alert] = t('fae.save_error')
        render action: 'edit'
      end
    end

    def destroy_old
      if @item.destroy
        redirect_to admin_interaction_contents_path(interaction_id: @item.interaction_id), notice: t('fae.delete_notice')
      else
        redirect_to admin_interaction_contents_path(interaction_id: @item.interaction_id), flash: { error: t('fae.delete_error') }
      end
    end


    private

    def build_assets
      @item.build_stimulus if @item.stimulus.blank?
    end

  end
end
