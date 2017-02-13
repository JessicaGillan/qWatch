require 'rails_helper'

RSpec.describe TMDB, type: :model do

  describe '.pull_movies' do

    it 'returns a JSON object' do
      VCR.use_cassette("tmdb/pull_movies") do
        response = TMDB.pull_movies
        expect(response).to be_a Hash
      end
    end

    it 'should have response["results"] when it is successful, indicated by response["success"]' do
      VCR.use_cassette("tmdb/pull_movies") do
        response = TMDB.pull_movies
        expect(response["results"]).to be_truthy
      end
    end

  end

end
