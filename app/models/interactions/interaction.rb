class Interaction < ApplicationRecord

  attr_writer :score

  belongs_to :goal
  has_many :contents, dependent: :destroy

  validates_presence_of :name

  # Types determine how the content's are presented and graded
  # Short Answer would have a two content records (one type: Prompt and one Type: criterion.rb).
  # The Prompt would be the question and the criterion would be the correct answer.
  # For multiple choice, there would be multiple criterion with only one that has a non-zero (1) score.
  validates_presence_of :type

  # default score is 1
  def score
    @score || 1
  end

  # Correct means the total possible score was achieved. In most cases the grade is simply  1
  # (eg. a multiple choice interaction)
  def correct? grade
    true  if grade == score
  end
end
