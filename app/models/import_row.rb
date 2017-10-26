class ImportRow < ApplicationRecord
  include Fae::BaseModelConcern
  include ActiveModel::Validations

  validates_with ImportRowValidator

  def fae_display_field
    title
  end

  # order by id for ease of review in sequential import
  default_scope { order('id') }


  belongs_to :import_file
  has_one :interaction

  def interaction
    Interaction.find_by_import_row_id(id)
  end

  def json
    JSON.parse(json_data)
  end
end
