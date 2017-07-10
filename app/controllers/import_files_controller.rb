class ImportFilesController < ApplicationController
  include CsvLoader

  before_action :set_goal
  before_action :set_json_data, only: [:create, :update]

  # GET /goals/:goal_id/import_files
  def index
    json_response(@goal.import_files)
  end

  # GET /goals/:goal_id/import_files/:id
  def show
    json_data_response(@import_file, :ok)
  end

  # POST /goals/:goal_id/import_files
  def create
    @import_file = @goal.import_files.create!(import_file_params)
    json_data_response(@import_file,:created)
  end

  # PUT /goals/:goal_id/import_files/:id
  def update
    @import_file.update(import_file_params)
    head :no_content
  end

  # DELETE /goals/:goal_id/import_files/:id
  def destroy
    @import_file.destroy
    head :no_content
  end

  private

  def import_file_params
    params.permit(:title, :json_data)
  end

  def set_goal
    # require the goal context for all import_file requests
    return unless params[:goal_id]
    @goal = Goal.preload(:import_files).find(params[:goal_id])
    @import_file = ImportFile.find(params[:id]) if params[:id]
  end

  # Load the json_date from the csv file if provided
  def set_json_data
    csvfile = params[:csvfile]
    return unless csvfile
    if csvfile.respond_to?(:tempfile)
      params[:json_data] = load(csvfile.tempfile)
    else
      params[:json_data] = load(csvfile) if File.file?(csvfile)
    end
  end

  # json_data contains the csv_file rows. It's stored as a string.
  # Convert the string to Json
  def json_data_response(import_file, status )
    response =
    {
        "id": import_file.id,
        "title": import_file.title,
        "goal_id": import_file.goal_id,
        "created_at": import_file.created_at,
        "updated_at": import_file.updated_at,
        "json_data": JSON.parse(import_file.json_data)
    }
    json_response(response, status)
  end
end