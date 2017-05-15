module Admin
  class AdminBaseController < Fae::BaseController

    # Set the index_path used for redirecting after an action.
    # Change required if the 2nd to last argument is the parents object id.
    # Adds the parent id parameter to index page used by Fae::BaseController redirect
    # to limit the scope of the index page to the parent
    def set_fae_variables(class_name = nil)
      klass_base = params[:controller].split('/').last
      @klass_name = class_name || klass_base               # used in form views
      @klass = klass_base.classify.constantize             # used as class reference in this controller
      @klass_singular = klass_base.singularize             # used in index views
      @klass_humanized = @klass_name.singularize.humanize  # used in index views
      @index_path = scoped_path                            # used in form_header and form_buttons partials
      @new_path = scoped_path('/new')                      # used in index_header partial
    end

    def scoped_path(action = '')
      return '/' + params[:controller] + action + scope
    end


  end
end