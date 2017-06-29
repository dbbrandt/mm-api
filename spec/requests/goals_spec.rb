# spec/requests/goals_spec.rb
require 'rails_helper'

RSpec.describe 'Goals API', type: :request do
  # initialize test data 
  let!(:goals) { create_list(:goal, 10) }
  let(:goal_id) { goals.first.id }

  # Test suite for GET /goals
  describe 'GET /goals' do
    # make HTTP get request before each example
    before { get '/goals' }

    it 'returns goals' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /goals/:id
  describe 'GET /goals/:id' do
    before { get "/goals/#{goal_id}" }

    context 'when the record exists' do
      it 'returns the goal' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(goal_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:goal_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Goal/)
      end
    end
  end

  # Test suite for POST /goals
  describe 'POST /goals' do
    # valid payload
    let(:valid_attributes) { { title: 'Learn Actor Names' } }

    context 'when the request is valid' do
      before { post '/goals', params: valid_attributes }

      it 'creates a goal' do
        expect(json['title']).to eq('Learn Actor Names')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/goals', params: nil }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
            .to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  # Test suite for PUT /goals/:id
  describe 'PUT /goals/:id' do
    let(:valid_attributes) { { title: 'Learn Actors Movies' } }

    context 'when the record exists' do
      before { put "/goals/#{goal_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record does not exists' do
      before { put "/goals/100", params: valid_attributes }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end


  end

  # Test suite for DELETE /goals/:id
  describe 'DELETE /goals/:id' do

    context 'when the record exists' do
      before { delete "/goals/#{goal_id}" }
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record does not exists' do
      before { delete "/goals/100" }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end


  end
end