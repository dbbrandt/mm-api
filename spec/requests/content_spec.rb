# spec/requests/contents_spec.rb
require 'rails_helper'

RSpec.describe 'Contents API', type: :request do
  # initialize test data
  let!(:interaction) { create(:interaction) }
  let!(:interaction_id) { interaction.id }
  let!(:contents) { create_list(:content, 10, interaction: interaction) }
  let(:content_id) { contents.first.id }
  let(:valid_attributes) { { title: 'Tom Hanks', content_type: 'Prompt' , copy: 'Test'} }


  # Test reject requests that are not permitted for this resource
  context 'requests without a interaction specified should fail' do
    describe 'GET /content' do
      it 'fails to find the route' do
        expect{ get "/content" }.to raise_error(ActionController::RoutingError)
      end
    end

    describe 'GET /contents/:id' do
      it 'fails to find the route' do
        expect{ get "/contents/#{content_id}" }.to raise_error(ActionController::RoutingError)
      end
    end

    describe 'PUT /contents/:id' do
      it 'fails to find the route' do
        expect{ put "/contents/#{content_id}" }.to raise_error(ActionController::RoutingError)
      end
    end

    describe 'POST /contents' do
      it 'fails to find the route' do
        expect{ post "/contents" }.to raise_error(ActionController::RoutingError)
      end
    end

    describe 'DELETE /contents/:id' do
      it 'fails to find the route' do
        expect{ delete "/contents/#{content_id}" }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  # Test requests that scoped  to the interaction
  context 'requests a interaction''s contents' do
    # Test suite for GET /interaction/:interaction_id/contents
    describe 'GET /interactions/:interaction_id/contents' do
      # make HTTP get request before each example
      before { get "/interactions/#{interaction_id}/contents" }

      it 'returns contents' do
        # Note `json` is a custom helper to parse JSON responses
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    # Test suite for GET /interaction/:interaction_id/contents/:id
    describe 'GET /interaction/:interaction_id/contents/:id' do
      context 'when the record exists' do
        before { get "/interactions/#{interaction_id}/contents/#{content_id}" }

        it 'returns the interaction' do
          expect(json).not_to be_empty
          expect(json['id']).to eq(content_id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the record does not exist' do
        before { get "/interactions/#{interaction_id}/contents/1000" }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to include("Couldn't find Content")
        end
      end
    end

    # Test suite for POST /interaction/:interaction_id/contents
    describe 'POST /interaction/:interaction_id/contents' do
      # valid payload
      context 'when the request is valid' do
        before { post "/interactions/#{interaction_id}/contents", params: valid_attributes }

        it 'creates a interaction' do
          expect(json['title']).to eq('Tom Hanks')
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'when the request is invalid' do
        before { post "/interactions/#{interaction_id}/contents", params: { title: "Meryl Streep", copy: "test"} }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
              .to match(/Validation failed: Content type is not included in the list/)
        end
      end
    end

    # Test suite for PUT /interaction/:interaction_id/contents/:id
    describe 'PUT /interaction/:interaction_id/contents/:id' do

      context 'when the record exists' do
        before { put "/interactions/#{interaction_id}/contents/#{content_id}", params: valid_attributes }

        it 'updates the record' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end

      context 'when the record does not exists' do
        before { put "/interactions/#{interaction_id}/contents/100", params: valid_attributes }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end
      end


    end

    # Test suite for DELETE /interaction/:interaction_id/contents/:id
    describe 'DELETE /interactions/:interaction_id/contents/:id' do

      context 'when the record exists' do
        before { delete "/interactions/#{interaction_id}/contents/#{content_id}" }

          it 'returns status code 204' do
            expect(response).to have_http_status(204)
          end
        end

      context 'when the record does not exists' do
        before { delete "/interactions/#{interaction_id}/contents/#{content_id}" }

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end
  end
end
