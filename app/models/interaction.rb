class Interaction < ApplicationRecord
  include Fae::BaseModelConcern

  TYPES = ['ShortAnswer','MultipleChoice']

  def fae_display_field
    title
  end

  #acts_as_list add_new_at: :top
  default_scope { order('updated_at DESC') }

  scope :short_answer, -> { where(answer_type: 'ShortAnswer')}
  scope :multiple_choice, -> { where(answer_type: 'MultipleChoice')}

  validates_presence_of :title
  validates_inclusion_of :answer_type, in: TYPES

  belongs_to :goal, required: true
  has_many :contents, :dependent => :destroy

  # Return the title if copy is not available
  def copy
    super || title
  end

  def stimulus_url
    return unless prompt
    url = prompt.stimulus&.asset&.url || ""
    url
  end

  def prompt
    contents.where(content_type: Content::PROMPT).first
  end

  def criterion
    contents.where(content_type: Content::CRITERION)
  end
end
