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

  describe 'check answer' do
    let(:interaction) do
      goal = create(:goal)
      interaction = create(:interaction, goal: goal)
      create(:content, :criterion, interaction: interaction)
      interaction
    end

    it 'detremines answer is incorrect' do
      correct, score = interaction.check_answer('wrong')
      expect(correct).to be_falsey
      expect(score).not_to eq(1)
    end

    it 'detrmines answer is correct' do
      correct, score = interaction.check_answer(interaction.correct_answer)
      expect(correct).to be_truthy
      expect(score).to eq(1)
    end
  end
end
