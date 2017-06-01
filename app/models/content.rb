class Content < ApplicationRecord
  include Fae::BaseModelConcern

  TYPES = ['Prompt', 'Criterion']

  def fae_display_field
    title
  end

  has_fae_image :stimulus

  belongs_to :interaction

  default_scope { order('updated_at DESC') }

  validates_presence_of :content_type
  validates_inclusion_of :content_type, in: TYPES

#  validates_presence_of :copy, unless: defined?(:stimulus)
  validates_presence_of :stimulus, unless: :copy?
end
