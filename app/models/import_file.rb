class ImportFile < ApplicationRecord
  include Fae::BaseModelConcern

  def fae_display_field
    title
  end

  validates_presence_of :title
  validates_presence_of :json_data

  default_scope { order(:title)}

  belongs_to :goal
end
