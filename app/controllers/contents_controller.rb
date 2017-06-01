class ContentsController < ApplicationController
  before_action :set_interaction
  before_action :set_interaction_content, only: [:show, :update, :destroy]

  # GET /interactions/:interaction_id/contents
  def index
    json_response(@interaction.contents)
  end

  # GET /interactions/:interaction_id/contents/:id
  def show
    json_response(@content)
  end

  # POST /interactions/:interaction_id/contents
  def create
    @interaction.contents.create!(content_params)
    json_response(@content, :created)
  end

  # PUT /interactions/:interaction_id/contents/:id
  def update
    @content.update(content_params)
    head :no_content
  end

  # DELETE /interactions/:interation_id/contents/:id
  def destroy
    @content.destroy
    head :no_content
  end

  private

  def content_params
    params.permit(:type, :description, :image_url, :copy, :score, :descriptor)
  end

  def set_interaction
    @interaction = Interaction.find(params[:interaction_id])
  end

  def set_interaction_content
    @content = @interaction.contents.select {|c| c[:id] == params[:id]} if @interaction
  end

end
