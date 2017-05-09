class Interaction < ApplicationRecord
  include Fae::BaseModelConcern

  TYPES = ['ShortAnswer','MultipleChoice']

  def fae_display_field
    title
  end

  #acts_as_list add_new_at: :top
  default_scope { order('updated_at DESC') }

  belongs_to :goal
  has_many :contents
end
