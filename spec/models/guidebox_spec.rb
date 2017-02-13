require 'rails_helper'

RSpec.describe Guidebox, type: :model do

  describe '.search_for_movie' do
    let(:valid_options) { { type: "movie", field: 'id', id_type: 'themoviedb', query: 602 } }
    let(:invalid_options) { { type: "movie", field: 'id', id_type: 'themoviedb', query: "xx234" } }

    it 'returns a JSON object' do
      expect(Guidebox.search_for_movie(valid_options)).to be_a Hash
    end

    it 'should return the movie id for a valid movie tmdb_id in it\'s database' do
      expect(Guidebox.search_for_movie(valid_options)["id"]).to be_an Integer
    end

    it 'should not return an id for an invalid movie tmdb_id' do
      expect(Guidebox.search_for_movie(invalid_options)["id"]).to be_falsey
    end

  end

  describe '.pull_movie_data' do
    let(:id) { 602 }
    let(:invalid_id) { "sad602" }

    it 'returns a JSON object' do
      expect(Guidebox.pull_movie_data(id)).to be_a Hash
    end

    it 'should return the movie id for a valid movie tmdb_id in it\'s database' do
      expect(Guidebox.pull_movie_data(id)["id"]).to be_an Integer
    end

    it 'should not return an id for an invalid movie tmdb_id' do
      expect(Guidebox.pull_movie_data(invalid_invalid)["id"]).to be_falsey
    end
  end

end
