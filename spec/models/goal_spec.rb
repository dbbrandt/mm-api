require 'rails_helper'

RSpec.describe Goal, type: :model do
  # Association test
  # ensure Goal model has a 1:m relationship with the Interaction model
  it { is_expected.to have_many(:interactions).dependent(:destroy) }
  it { is_expected.to have_many(:contents) }

  # Validation tests
  # ensure columns name and type are present before saving
  it { is_expected.to validate_presence_of(:title) }
end
