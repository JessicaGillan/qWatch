require 'rails_helper'

RSpec.describe TMDB, type: :model do

  describe '.pull_movies' do

    it 'returns a JSON object' do
      expect(TMDB.pull_movies).to be_a Hash
    end

    it 'should have response["results"] when it is successful, indicated by response["success"]' do
      expect(TMDB.pull_movies["success"]).to be true
      expect(TMDB.pull_movies["results"]).to be_truthy
    end

  end

end
