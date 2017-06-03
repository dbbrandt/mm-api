class Goal < ApplicationRecord
  include Fae::BaseModelConcern

  def fae_display_field
    title
  end

  validates_presence_of :title

  has_fae_image :hero_image

  default_scope { order('title')}

  has_many :interactions, :dependent => :destroy
  has_many :contents, through: :interactions
end
