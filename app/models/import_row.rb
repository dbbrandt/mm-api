class ImportRow < ApplicationRecord
  include Fae::BaseModelConcern
  include ActiveModel::Validations

  validates_uniqueness_of :title, scope: :import_file_id
  validates_with ImportRowValidator

  def fae_display_field
    title
  end

  # order by id for ease of review in sequential import
  default_scope { order('id') }

  belongs_to :import_file
  has_one :interaction

  def json
    @json ||= JSON.parse(json_data)
  end
end
