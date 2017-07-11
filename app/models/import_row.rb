class ImportRow < ApplicationRecord
  include Fae::BaseModelConcern

  def fae_display_field
    title
  end

  # order by id for ease of review in sequential import
  default_scope { order('id') }

  validates_presence_of :title
  validates_presence_of :json_data

  belongs_to :import_file
  has_one :interaction

  def interaction
    Interaction.find_by_import_row_id(id)
  end
end
