# spec/requests/import_files_spec.rb
require 'rails_helper'

RSpec.describe 'import_file API', type: :request do
  # initialize test data
  let(:csv_filename) { "test.csv" }
  let!(:goal) { create(:goal) }
  let!(:goal_id) { goal.id }
  let!(:import_files) { create_list(:import_file, 10, goal: goal) }
  let(:import_file_id) { import_files.first.id }
  let(:valid_attributes)  { { :title => 'Test Quiz', :file => "TODO - SIMULATE ACTUAL FILE" } }

  let(:json_key) { "title" }
  let(:json_value) { "Downside of strings" }
  let(:json_value1) { "Cost of strings" }

  # Test reject requests that are not permitted for this resource
  context 'requests without a goal specified should fail' do
    describe 'GET /import_files' do
      it 'fails to find the route' do
        expect{ get "/import_Files" }.to raise_error(ActionController::RoutingError)
      end
    end

    describe 'GET /import_files/:id' do
      it 'fails to find the route' do
        expect{ get "/import_files/#{import_file_id}" }.to raise_error(ActionController::RoutingError)
      end
    end

    describe 'PUT /import_files/:id' do
      it 'fails to find the route' do
        expect{ put "/import_files/#{import_file_id}" }.to raise_error(ActionController::RoutingError)
      end
    end

    describe 'POST /import_files' do
      it 'fails to find the route' do
        expect{ post "/import_files" }.to raise_error(ActionController::RoutingError)
      end
    end

    describe 'DELETE /import_files/:id' do
      it 'fails to find the route' do
        expect{ delete "/import_files/#{import_file_id}" }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  # Test requests that scoped  to the goal
  context 'requests that are scoped to the goal' do
    # Test suite for GET /goal/:goal_id/import_files
    describe 'GET /goals/:goal_id/import_files' do
      # make HTTP get request before each example
      before { get "/goals/#{goal_id}/import_files" }

      it 'returns import_files' do
        # Note `json` is a custom helper to parse JSON responses
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      # Test suite for GET /goal/:goal_id/import_files/:id
      describe ' Get /goal/:goal_id/import_files/:id' do
        context 'when the record exists' do
          before { get "/goals/#{goal_id}/import_files/#{import_file_id}" }

          it 'returns the import_file' do
            expect(json).not_to be_empty
            expect(json['id']).to eq(import_file_id)
            expect(json['json_data']).not_to be_empty
          end

          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end
        end

        context 'when the record does not exist' do
          before { get "/goals/#{goal_id}/import_files/1000" }

          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end

          it 'returns a not found message' do
            expect(response.body).to include("Couldn't find Import File")
          end
        end
      end
    end

    # Test suite for POST /goal/:goal_id/import_files
    describe 'POST /goal/:goal_id/import_files' do
      # valid payload
      context 'when the request is valid' do
        #TODO handle params as a file upload
        before { post "/goals/#{goal_id}/import_files", params: valid_attributes }

        it 'creates an import_file' do
          expect( json_data[0][json_key] ).to eq(json_value)
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'when the request is invalid' do
        before { post "/goals/#{goal_id}/import_files", params: { title: "Test Quiz"} }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
              .to match(/Validation failed: File not provided/)
        end
      end
    end


    # Test suite for PUT /goal/:goal_id/import_files/:id
    describe 'PUT /goal/:goal_id/import_files/:id' do

      context 'when the record exists' do
        #TODO handle params as a file upload
        before { put "/goals/#{goal_id}/import_files/#{import_file_id}", params: valid_attributes }

        it 'updates the record' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end

      context 'when the record does not exists' do
        before { put "/goals/#{goal_id}/import_files/100", params: valid_attributes }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end
      end
    end

    # Test suite for DELETE /goal/:goal_id/import_files/:id
    describe 'DELETE /goals/:goal_id/import_files/:id' do

      context 'when the record exists' do
        before { delete "/goals/#{goal_id}/import_files/#{import_file_id}" }

          it 'returns status code 204' do
            expect(response).to have_http_status(204)
          end

        end

      context 'when the record does not exists' do
        before { delete "/goals/#{goal_id}/import_files/100" }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end