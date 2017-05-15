module Admin
  class InteractionsController < AdminBaseController
    before_action :set_goal

    def index
      if @goal
        @items = Interaction.where(goal_id: @goal.id)
      else
        @items = Interaction.all
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

    private

    def set_goal
      #@goal = params[:goal]? Goal.find_by_id(params[:goal]) : Goal.find_by_id(params[:goal_id])
      @goal = Goal.find_by_id(params[:goal_id])
    end

    def set_class_variables(class_name = nil)
      set_fae_variables
      @index_path = scoped_path                            # used in form_header and form_buttons partials
      @new_path = scoped_path('/new')                      # used in index_header partial
    end

    # add a parameter to the index path to scope the view to the parent
    def scoped_path(action = '')
      set_goal
      scope = @goal? "?goal_id=#{@goal.id}" : ''
      return '/' + params[:controller] + action + scope
    end

  end
end
