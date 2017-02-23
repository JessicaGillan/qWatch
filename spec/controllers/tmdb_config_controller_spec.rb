require 'rails_helper'

RSpec.describe TMDBConfigController, type: :request do
  describe 'GET index' do
    before do
      get tmdb_config_index_url
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it 'returns the json config settings' do
      expect(json).to be_a Hash
    end

    it 'returns The Movie Database config settings' do
      expect(json.keys).to include("id", "url", "created_at", "updated_at", "secure_url", "sizes")
    end
  end
end
