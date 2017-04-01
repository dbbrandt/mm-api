# app/requests/interactions_spec.rb
require 'rails_helper'

RSpec.describe 'Interactions API' do
  # Initialize the test data
  let!(:goal) { create(:goal) }
  let!(:interactions) { create_list(:interaction, 20, goal_id: goal.id) }
  let(:goal_id) { goal.id }
  let(:id) { interactions.first.id }

  # Test suite for GET /goals/:goal_id/interactions
  describe 'GET /goals/:goal_id/interactions' do
    before { get "/goals/#{goal_id}/interactions" }

    context 'when goal exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all goal interactions' do
        expect(json.size).to eq(20)
      end
    end

    context 'when goal does not exist' do
      let(:goal_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Goal/)
      end
    end
  end

  # Test suite for GET /goals/:goal_id/interactions/:id
  describe 'GET /goals/:goal_id/interactions/:id' do
    before { get "/goals/#{goal_id}/interactions/#{id}" }

    context 'when goal interaction exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the interaction' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when goal interaction does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Interaction/)
      end
    end
  end

  # Test suite for PUT /goals/:goal_id/interactions
  describe 'POST /goals/:goal_id/interactions' do
    let(:valid_attributes) { { name: 'Tom Hanks', type: 'ShortAnswer' } }

    context 'when request attributes are valid' do
      before { post "/goals/#{goal_id}/interactions", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/goals/#{goal_id}/interactions", params: {} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /goals/:goal_id/interactions/:id
  describe 'PUT /goals/:goal_id/interactions/:id' do
    let(:valid_attributes) { { name: 'Merryl Streep' } }

    before { put "/goals/#{goal_id}/interactions/#{id}", params: valid_attributes }

    context 'when interaction exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the interaction' do
        updated_interaction = Interaction.find(id)
        expect(updated_interaction.name).to match(/Merryl Streep/)
      end
    end

    context 'when the interaction does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Interaction/)
      end
    end
  end

  # Test suite for DELETE /goals/:id
  describe 'DELETE /goals/:id' do
    before { delete "/goals/#{goal_id}/interactions/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end