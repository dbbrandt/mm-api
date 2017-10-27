class Interaction < ApplicationRecord
  include Fae::BaseModelConcern

  TYPES = ['ShortAnswer','MultipleChoice']

  def fae_display_field
    title
  end

  #acts_as_list add_new_at: :top
  default_scope { order('updated_at DESC') }

  validates_presence_of :title
  validates_inclusion_of :answer_type, in: TYPES

  belongs_to :goal
  has_many :contents, :dependent => :destroy

  # Return the title if copy is not available
  def copy
    super || title
  end
end
