require 'rails_helper'

RSpec.describe Interaction, type: :model do
  # Association test
  # ensure Goal model has a 1:m relationship with the Interaction model
  it { is_expected.to belong_to :goal }
  it { is_expected.to have_many(:contents).dependent(:destroy) }

  # Validation tests
  # ensure columns name and type are present before saving
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_inclusion_of(:answer_type).in_array(Interaction::TYPES) }

end
