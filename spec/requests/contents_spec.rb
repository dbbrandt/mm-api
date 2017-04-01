# app/requests/contents_spec.rb
require 'rails_helper'

RSpec.describe 'Contents API' do
  # Initialize the test data
  let!(:goal) { create(:goal) }
  let!(:gaol_id) { goal.id }
  let!(:interaction) { create(:interaction, goal_id: goal.id) }
  let!(:contents) { create_list(:content, 20, interaction_id: interaction.id) }
  let(:interaction_id) { interaction.id }
  let(:id) { contents.first.id }

  # Test suite for GET /interactions/:interaction_id/contents
  describe 'GET /interactions/:interaction_id/contents' do
    before { get "/interactions/#{interaction_id}/contents" }

    context 'when interaction exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all interaction contents' do
        expect(json.size).to eq(20)
      end
    end

    context 'when interaction does not exist' do
      let(:interaction_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Interaction/)
      end
    end
  end

  # Test suite for GET /interactions/:interaction_id/contents/:id
  describe 'GET /interactions/:interaction_id/contents/:id' do
    before { get "/interactions/#{interaction_id}/contents/#{id}" }

    context 'when interaction content exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the content' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when interaction content does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Content/)
      end
    end
  end

  # Test suite for PUT /interactions/:interaction_id/contents
  describe 'POST /interactions/:interaction_id/contents' do
    let(:valid_attributes) { { type: 'Prompt', copy: "Tom Hanks" } }

    context 'when request attributes are valid' do
      before { post "/interactions/#{interaction_id}/contents", params: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/interactions/#{interaction_id}/contents", params: {copy: 'Tom Hanks'} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Type can't be blank/)
      end
    end
  end

  # Test suite for PUT /interactions/:interaction_id/contents/:id
  describe 'PUT /interactions/:interaction_id/contents/:id' do
    let(:valid_attributes) { { copy: 'Merryl Streep' } }

    before { put "/interactions/#{interaction_id}/contents/#{id}", params: valid_attributes }

    context 'when content exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the content' do
        updated_content = Content.find(id)
        expect(updated_content.copy).to match(/Merryl Streep/)
      end
    end

    context 'when the content does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Content/)
      end
    end
  end

  # Test suite for DELETE /interactions/:id
  describe 'DELETE /interactions/:id' do
    before { delete "/interactions/#{interaction_id}/contents/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end