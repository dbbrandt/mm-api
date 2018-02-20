module Admin
  class ImportRowsController < Fae::BaseController
    before_action :set_import_file

    def index
      if @import_file
        @items = ImportRow.where(import_file_id: @import_file.id)
      else
        @items = ImportRow.all
      end
    end

    def set_import_file
      cookies[:import_file_id] = params[:import_file_id] if params[:import_file_id]
      @import_file = ImportFile.find_by_id(cookies[:import_file_id])
    end

  end
end
