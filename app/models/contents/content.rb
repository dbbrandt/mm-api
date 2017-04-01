class Content < ApplicationRecord
  belongs_to :interaction

  validates_presence_of :type

  validates_presence_of :copy, :unless => :image_url?
  validates_presence_of :image_url, :unless => :copy?
end
