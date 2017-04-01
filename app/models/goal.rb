class Goal < ApplicationRecord
  has_many :interactions, dependent: :destroy

  validates_presence_of :name
end
