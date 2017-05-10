module Admin
  class InteractionsController < Fae::BaseController

    def show
      @items = Goal.find_by_id(params[:goal_id]).interactions
      @goal = @items.first.goal
    end

    def new
      @goal = Goal.find_by_id(params[:goal_id])
      super
    end

    def create
      return create_from_existing(params[:from_existing]) if params[:from_existing].present?

      @item = @klass.new(item_params)

      if @item.save
        #redirect_to @index_path, notice: t('fae.save_notice')
        redirect_to admin_goal_interactions_path(goal_id: @item.goal_id), notice: t('fae.save_notice')
      else
        build_assets
        flash[:alert] = t('fae.save_error')
        render action: 'new'
      end
    end

    def filter
      @items = Goal.find_by_id(params[:goal]).interactions
      respond_to do |format|
        format.html {
          render :text => '<tbody aria-live="polite" aria-relevant="all"><tr id="interaction_5" role="row"><td><a href="/admin/interactions/5/edit">New Jonah Hill</a></td><td>05/09/17</td><td><a title="Delete" class="js-tooltip table-action tooltip-parent" data-confirm="Are you sure you want to permanently delete this item?" rel="nofollow" data-method="delete" href="/admin/interactions/5"><span class="tooltip">Delete</span><i class="icon-trash"></i></a></td></tr><tr id="interaction_6" role="row"><td><a href="/admin/interactions/6/edit">Martin Sheen</a></td><td>05/09/17</td><td><a title="Delete" class="js-tooltip table-action tooltip-parent" data-confirm="Are you sure you want to permanently delete this item?" rel="nofollow" data-method="delete" href="/admin/interactions/6"><span class="tooltip">Delete</span><i class="icon-trash"></i></a></td></tr><tr id="interaction_4" role="row"><td><a href="/admin/interactions/4/edit">Meryl Streep</a></td><td>05/08/17</td><td><a title="Delete" class="js-tooltip table-action tooltip-parent" data-confirm="Are you sure you want to permanently delete this item?" rel="nofollow" data-method="delete" href="/admin/interactions/4"><span class="tooltip">Delete</span><i class="icon-trash"></i></a></td></tr><tr id="interaction_3" role="row"><td><a href="/admin/interactions/3/edit">Tom Hanks</a></td><td>05/08/17</td><td><a title="Delete" class="js-tooltip table-action tooltip-parent" data-confirm="Are you sure you want to permanently delete this item?" rel="nofollow" data-method="delete" href="/admin/interactions/3"><span class="tooltip">Delete</span><i class="icon-trash"></i></a></td></tr></tbody>'
        }
      end
    end

  end
end
