require 'rails_helper'

RSpec.describe ImportRow, type: :model do

  let!(:goal) { create(:goal) }
  let!(:import_file) { create(:import_file, goal: goal) }
  let!(:import_rows)  { create_list(:import_row, 2, import_file: import_file) }
  let!(:interaction) { create(:interaction, goal: goal, import_row_id: import_rows[0].id) }

  # Association test
  # ensure Goal model has a 1:m relationship with the Interaction model
  it { is_expected.to belong_to :import_file }

  # Validation tests
  # ensure columns name and type are present before saving
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:json_data) }

  describe 'get related interaction row' do
    context 'related interaction was created' do
      it 'find an interaction' do
        expect(import_rows[0].interaction.id).to eq(interaction.id)
      end
    end

    context 'related interaction was not created' do
      it 'does not find an interaction' do
        expect(import_rows[1].interaction).to be_nil
      end
    end
  end
end
