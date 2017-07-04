class Content < ApplicationRecord
  include Fae::BaseModelConcern

  TYPES = ['Prompt', 'Criterion']

  def fae_display_field
    title
  end
  
  has_fae_image :stimulus

  belongs_to :interaction

  default_scope { order(:title) }

  validates_presence_of :title
  validates_inclusion_of :content_type, in: TYPES

  validates_presence_of :stimulus, unless: :copy?
end
