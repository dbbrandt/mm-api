class ImportRowsController < ApplicationController
  before_action :set_import_file

  # GET /import_file/:import_file_id/import_rows
  def index
    json_response(@import_file.import_rows)
  end

  # GET /import_file/:import_file_id/import_rows/:id
  def show
    json_response(@import_row)
  end

  # POST /import_file/:import_file_id/import_rows
  def create
    @import_row = @import_file.import_rows.create!(import_row_params)
    json_response(@import_row, :created)
  end

  # PUT /import_file/:import_file_id/import_rows/:id
  def update
    @import_row.update(import_row_params)
    head :no_content
  end

  # DELETE /import_file/:import_file_id/import_rows/:id
  def destroy
    @import_row.destroy
    head :no_content
  end

  #
  private

  def import_row_params
    params.permit(:title, :json_data)
  end

  def set_import_file
    # require the goal context for all import_row requests
    return unless params[:import_file_id]
    @import_file = ImportFile.preload(:import_rows).find(params[:import_file_id])
    @import_row = ImportRow.find(params[:id]) if params[:id]
  end

end

