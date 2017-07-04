# spec/requests/interactions_spec.rb
require 'rails_helper'

RSpec.describe 'interactions API', type: :request do
  # initialize test data
  let!(:goal) { create(:goal) }
  let!(:goal_id) { goal.id }
  let!(:interactions) { create_list(:interaction, 10, goal: goal) }
  let(:interaction_id) { interactions.first.id }
  let(:valid_attributes) { { title: 'Tom Hanks', answer_type: 'ShortAnswer' } }


  # Test reject requests that are not permitted for this resource
  context 'requests without a goal specified should fail' do
    describe 'GET /interactions' do
      it 'fails to find the route' do
        expect{ get "/interaction" }.to raise_error(ActionController::RoutingError)
      end
    end

    describe 'GET /interacctions/:id' do
      it 'fails to find the route' do
        expect{ get "/interactions/#{interaction_id}" }.to raise_error(ActionController::RoutingError)
      end
    end

    describe 'PUT /interacctions/:id' do
      it 'fails to find the route' do
        expect{ put "/interactions/#{interaction_id}" }.to raise_error(ActionController::RoutingError)
      end
    end

    describe 'POST /interactions' do
      it 'fails to find the route' do
        expect{ post "/interactions" }.to raise_error(ActionController::RoutingError)
      end
    end

    describe 'DELETE /interacctions/:id' do
      it 'fails to find the route' do
        expect{ delete "/interactions/#{interaction_id}" }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  # Test requests that scoped  to the goal
  context 'requests a goal''s interactions' do
    # Test suite for GET /goal/:goal_id/interactions
    describe 'GET /goals/:goal_id/interactions' do
      # make HTTP get request before each example
      before { get "/goals/#{goal_id}/interactions" }

      it 'returns interactions' do
        # Note `json` is a custom helper to parse JSON responses
        expect(json).not_to be_empty
        expect(json.size).to eq(10)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    # Test suite for GET /goal/:goal_id/interactions/:id
    describe 'GET /interactions/:id' do
      context 'when the record exists' do
        before { get "/goals/#{goal_id}/interactions/#{interaction_id}" }

        it 'returns the interaction' do
          expect(json).not_to be_empty
          expect(json['id']).to eq(interaction_id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the record does not exist' do
        before { get "/goals/#{goal_id}/interactions/1000" }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to include("Couldn't find Interaction")
        end
      end
    end

    # Test suite for POST /interactions
    describe 'POST /interactions' do
      # valid payload
      context 'when the request is valid' do
        before { post "/goals/#{goal_id}/interactions", params: valid_attributes }

        it 'creates a interaction' do
          expect(json['title']).to eq('Tom Hanks')
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'when the request is invalid' do
        before { post "/goals/#{goal_id}/interactions", params: { title: "Meryl Streep"} }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
              .to match(/Validation failed: Answer type is not included in the list/)
        end
      end
    end

    # Test suite for PUT /interactions/:id
    describe 'PUT /interactions/:id' do

      context 'when the record exists' do
        before { put "/goals/#{goal_id}/interactions/#{interaction_id}", params: valid_attributes }

        it 'updates the record' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end

      context 'when the record does not exists' do
        before { put "/goals/#{goal_id}/interactions/100", params: valid_attributes }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end
      end


    end

    # Test suite for DELETE /interactions/:id
    describe 'DELETE /goals/:goal_id/interactions/:id' do

      context 'when the record exists' do
        before { delete "/goals/#{goal_id}/interactions/#{interaction_id}" }

          it 'returns status code 204' do
            expect(response).to have_http_status(204)
          end
        end

      context 'when the record does not exists' do
        before { delete "/goals/#{goal_id}/interactions/100" }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end