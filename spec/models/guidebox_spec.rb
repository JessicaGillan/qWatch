require 'rails_helper'

RSpec.describe Guidebox, type: :model do


  describe '.search_for_movie' do
    let(:valid_options) { { type: "movie", field: 'id', id_type: 'themoviedb', query: 602 } }
    let(:invalid_options) { { type: "movie", field: 'id', id_type: 'themoviedb', query: 348957349 } }

    # DO NOT CALL GUIDEBOX API UNLESS NEED TO TEST EXPLICITLY
  #   it 'returns a JSON object' do
  #     VCR.use_cassette("guidebox/valid_search") do
  #       response = Guidebox.search_for_movie(valid_options)
  #       expect(response).to be_a Hash
  #     end
  #   end
  #
  #   it 'should return the correct movie for a valid movie tmdb_id in it\'s database' do
  #     VCR.use_cassette("guidebox/valid_search") do
  #       response = Guidebox.search_for_movie(valid_options)
  #       expect(response["id"]).to be_an Integer
  #       expect(response["themoviedb"]).to eq 602
  #     end
  #   end
  #
  #   it 'should not return an id for an invalid movie tmdb_id' do
  #     VCR.use_cassette("guidebox/invalid_search") do
  #       response = Guidebox.search_for_movie(invalid_options)
  #       expect(response["themoviedb"]).not_to eq 348957349
  #     end
  #   end
  #
  end
  #
  describe '.pull_movie_data' do
  #   let(:id) { 602 }
  #   let(:invalid_id) { "sad602" }
  #
  #   it 'returns a JSON object' do
  #     VCR.use_cassette("guidebox/valid_data") do
  #       response = Guidebox.pull_movie_data(id)
  #       expect(response).to be_a Hash
  #     end
  #   end
  #
  #   it 'should return the movie id for a valid movie tmdb_id in it\'s database' do
  #     VCR.use_cassette("guidebox/valid_data") do
  #       response = Guidebox.pull_movie_data(id)
  #       expect(response["id"]).to be_an Integer
  #     end
  #   end
  #
  #   it 'should not return an id for an invalid movie tmdb_id' do
  #     VCR.use_cassette("guidebox/invalid_data") do
  #       response = Guidebox.pull_movie_data(invalid_id)
  #       expect(response["id"]).to be_falsey
  #     end
  #   end
  end

end
