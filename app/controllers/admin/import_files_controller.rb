module Admin
  class ImportFilesController < Fae::BaseController
    include CsvLoader

    def create
      csv_file = params[:import_file][:csv_file]
      if csv_file.respond_to?(:tempfile)
        params[:import_file][:json_data] = load(csv_file.tempfile) if csv_file.respond_to?(:tempfile)
      end
      super
      if @item.errors.empty? && csv_file
        errors = @item.create_rows
        @item.errors.add(:json_data, errors)
      end
    end

  end
end
