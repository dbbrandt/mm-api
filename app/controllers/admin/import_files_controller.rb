module Admin
  class ImportFilesController < Fae::BaseController
    include CsvLoader

    def create
      return create_from_existing(params[:from_existing]) if params[:from_existing].present?

      load_json_data
      @item = @klass.new(item_params)

      ImportFile.transaction do
        if @item.save
          errors = @item.create_rows
          if !errors.empty?
            @item.errors.add(:json_data, errors) unless errors.empty?
            raise ActiveRecord::Rollback
          end
        end
      end

      if @item.errors.empty?
        redirect_to @index_path, notice: t('fae.save_notice')
      else
        build_assets
        flash[:alert] = t('fae.save_error')
        render action: 'new'
      end
    end

    def generate
      return unless params[:id]
      @item = ImportFile.find(params[:id])
      errors = @item.generate_interactions
      if errors.empty?
        flash[:notice] = t('fae.save_notice')
      else
        flash[:alert] =  errors
      end
      redirect_to action: "index"
    end

    private

    def load_json_data
      csv_file = params[:import_file][:csv_file]
      if csv_file.respond_to?(:tempfile)
        params[:import_file][:json_data] = load(csv_file.tempfile)
      end
    end
  end
end
