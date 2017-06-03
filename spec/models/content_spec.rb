require 'rails_helper'

RSpec.describe Content, type: :model do
  # Association test
  # ensure Goal model has a 1:m relationship with the Interaction model
  it { is_expected.to belong_to(:interaction) }

  # Validation tests
  # ensure columns name and type are present before saving
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_inclusion_of(:content_type).in_array(Content::TYPES) }

  it "is invalid without stimulus if copy is missing" do
    content = Content.new(:title => 'title', :content_type => 'Prompt')

    content.validate
    expect(content.errors[:stimulus]).to include("can't be blank")

    content.copy = 'Copy'
    expect(content).to be_valid
  end
end
