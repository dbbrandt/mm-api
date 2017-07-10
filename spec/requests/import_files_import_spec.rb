# spec/requests/interactions_spec.rb
require 'rails_helper'

RSpec.describe 'import_files import interaction API', type: :request do

  # initialize test data
  let(:csv_filename) { Rails.root.join "spec/fixtures/RubyQuiz.csv" }
  let!(:goal) { create(:goal) }
  let!(:goal_id) { goal.id }
  let!(:import_file) { create(:import_file, goal: goal) }
  let(:import_file_id) { import_file.id }
  let(:valid_import_file_params)  { { :title => 'Test Quiz', :csvfile => csv_filename } }

  let!(:interactions) { create_list(:interaction, 10, goal: goal, import_file_id: import_file_id) }
  let(:interaction_id) { interactions.first.id }
  let(:invalid_csv_filename) { Rails.root.join "spec/fixtures/RubyQuizBad.csv" }
  let(:invalid_import_file_params)  { { :title => 'Test Quiz', :csvfile => invalid_csv_filename } }

  context 'Valid interactions requests' do
    # Test suite for GET /goals/:goals_id/import_files/:import_file_id/interactions
    describe 'GET /goals/:goals_id/import_filess/:import_file_id/interactions' do
      # make HTTP get request before each example
      before { get "/goals/:goals_id/import_filess/#{import_file_id}/interactions" }

      it 'returns import_files interactions' do
        # Note `json` is a custom helper to parse JSON responses
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      # Test suite for GET /goals/:goals_id/import_filess/:import_file_id/interaction/:id
      describe 'GET /goals/:goals_id/import_filess/:import_file_id/interaction/:id' do
        context 'when the record exists' do
          before { get "/goals/:goals_id/import_filess/#{import_file_id}/interaction/#{interaction_id}" }

          it 'returns the import_file interaction' do
            expect(json).not_to be_empty
            expect(json['id']).to eq(interaction_id)
          end

          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end
        end

        context 'when the record does not exist' do
          before { get "/goals/:goals_id/import_filess/#{import_file_id}/interaction/100" }

          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to include("Couldn't find Interaction")
          end
        end
      end
    end

    # Test suite for POST /goals/:goals_id/import_files/:import_file_id/interactions
    describe 'POST /goals/:goals_id/import_files/:import_file_id/import' do
      before do
        post "/goals/#{goal_id}/import_files", params: valid_import_file_params
        @import_file_id = json["id"]
        @csv_rows = json["json_data"].size
      end

      # valid payload
      context 'when the request cvs file is valid' do
        before do
          post "/goals/:goals_id/import_filess/#{@import_file_id}/import"
        end

        it 'creates interactions' do
          expect( json.size ).to eq(@csv_rows)
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'when the request is invalid' do
        before do
          post "/goals/#{goal_id}/import_files", params: invalid_import_file_params
          @import_file_id = json["id"]
          @csv_rows = json["json_data"].size
          post "/goals/#{goal_id}/import_files/#{@import_file_id}/import"
        end

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(json["message"])
              .to match(/Validation failed: At least one row could not be processed./)
        end
      end

      context 'when the import_file has already been loaded' do
        before do
          post "/goals/#{goal_id}/import_files/#{@import_file_id}/import"
        end

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(json["message"])
              .to match(/Validation failed: Import file already processed./)
        end
      end
    end

    # Test suite for DELETE /import_file/:import_file_id/interactions
    # Purge all interactions loaded from the import file
    # Note: TODO test case where this will not purge interactions that have already been used (are related to other data)
    context 'imported interactions that have no other related data (e.g. have been used)' do
      describe 'DELETE /import_file/:import_file_id/interactions' do
        before do
          post "/goals/#{goal_id}/import_files", params: valid_import_file_params
          @import_file_id = json["id"]
          @csv_rows = json["json_data"].size
          get "/goals/#{goal_id}//import_files/#{@import_file_id}/interactions"
        end

        it 'returns status code 204' do
          expect(json.size).to eq(@csv_rows)
          delete "/goals/#{goal_id}/import_files/#{@import_file_id}/interactions"
          expect(response).to have_http_status(204)
        end
      end
     end

    context 'imported interactions that have relatd data' do
      pending "Don't delete any intractions that have related rows (e.g. the have been used)"
    end

  end
end