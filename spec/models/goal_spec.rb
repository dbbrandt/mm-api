require 'rails_helper'

RSpec.describe Goal, type: :model do
  # Association test
  # ensure Goal model has a 1:m relationship with the Interaction model
  it { should have_many(:interactions).dependent(:destroy) }

  # Validation tests
  # ensure columns name and type are present before saving
  it { should validate_presence_of(:name) }
end
