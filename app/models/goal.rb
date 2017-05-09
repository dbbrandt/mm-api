class Goal < ApplicationRecord
  include Fae::BaseModelConcern

  def fae_display_field
    title
  end

  has_fae_image :hero_image

  has_many :interactions
end
