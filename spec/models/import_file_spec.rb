require 'rails_helper'

RSpec.describe ImportFile, type: :model do
  # Association test
  # ensure Goal model has a 1:m relationship with the Interaction model
  it { is_expected.to belong_to :goal }
  it { is_expected.to have_many(:import_rows).dependent(:destroy) }

  # Validation tests
  # ensure columns name and type are present before saving
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:json_data) }

  let!(:goal) { create(:goal) }
  let!(:import_file) { create(:import_file, goal: goal) }

  describe 'create_rows from import file' do
    context 'related import_rows do not already exist' do
      it 'creates import rows' do
        expect(import_file.import_rows.size).to eq(0)
        import_file.create_rows
        import_file.reload
        expect(import_file.import_rows.size).to be > 0
      end
    end

    context 'related import_rows were already created' do
      it 'does not create more import rows' do
        import_file.create_rows
        row_count = import_file.import_rows.size
        expect(row_count).to be > 0
        import_file.create_rows
        import_file.reload
        expect(import_file.import_rows.size).to eq(row_count)
      end
    end
  end

  describe 'delete_rows from import file' do
    before { import_file.create_rows }

    it 'deletes import rows' do
      expect(import_file.import_rows.size).to be > 0
      import_file.delete_rows
      import_file.reload
      expect(import_file.import_rows.size).to eq(0)
    end
  end

  describe 'generate interactions for import rows' do
    before { import_file.create_rows }

    it 'generates interaction rows' do
      expect(goal.interactions.size).to eq(0)
      import_file.generate_interactions
      goal.reload
      expect(goal.interactions.size).to be > 0
    end
  end
end
