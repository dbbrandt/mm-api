# spec/requests/interactions_spec.rb
require 'rails_helper'

RSpec.describe 'interactions API', type: :request do
  # initialize test data
  let!(:goal) { create}
  let!(:interactions) { create_list(:interaction, 10) }
  let(:interaction_id) { interactions.first.id }

  # Test reject requests that are not permitted for this resource
  context 'requests without goal specified' do
    describe 'GET /interacctions' do
      it 'returns status code 200' do
        get '/interactions'
        expect(response).to have_http_status(405)
      end
    end

    describe 'GET /interacctions/:id' do
      it 'returns status code 405' do
        get "/interactions/#{interaction_id}"
        expect(response).to have_http_status(405)
      end
    end

    describe 'PUT /interacctions/:id' do
      it 'returns status code 405' do
        put "/interactions/#{interaction_id}"
        expect(response).to have_http_status(405)
      end
    end

    describe 'POST /interacctions/:id' do
      it 'returns status code 405' do
        post "/interactions/#{interaction_id}"
        expect(response).to have_http_status(405)
      end
    end

    describe 'DELETE /interacctions/:id' do
      it 'returns status code 405' do
        delete "/interactions/#{interaction_id}"
        expect(response).to have_http_status(405)
      end
    end

  end


  # Test requests that scoped  to the goal
  context 'requests goal specified' do
    # Test suite for GET /goal/:goal_id/interactions
    describe 'GET /goal/:goal_id/interactions' do
      # make HTTP get request before each example
      before { get '/interactions' }

      it 'returns interactions' do
        # Note `json` is a custom helper to parse JSON responses
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    # Test suite for GET /interactions/:id
    describe 'GET /interactions/:id' do
      before { get "/interactions/#{interaction_id}" }

      context 'when the record exists' do
        it 'returns the interaction' do
          expect(json).not_to be_empty
          expect(json['id']).to eq(interaction_id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the record does not exist' do
        let(:interaction_id) { 100 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find interaction/)
        end
      end
    end

    # Test suite for POST /interactions
    describe 'POST /interactions' do
      # valid payload
      let(:valid_attributes) { { title: 'Tom Hanks' } }

      context 'when the request is valid' do
        before { post '/interactions', params: valid_attributes }

        it 'creates a interaction' do
          expect(json['title']).to eq('Tom Hanks')
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'when the request is invalid' do
        before { post '/interactions', params: nil }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
              .to match(/Validation failed: Title can't be blank/)
        end
      end
    end

    # Test suite for PUT /interactions/:id
    describe 'PUT /interactions/:id' do
      let(:valid_attributes) { { title: 'Meryl Streep' } }

      context 'when the record exists' do
        before { put "/interactions/#{interaction_id}", params: valid_attributes }

        it 'updates the record' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end

    # Test suite for DELETE /interactions/:id
    describe 'DELETE /interactions/:id' do
      before { delete "/interactions/#{interaction_id}" }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
end