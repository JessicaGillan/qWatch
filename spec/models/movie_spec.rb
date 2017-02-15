require 'rails_helper'

RSpec.describe Movie, type: :model do
  let(:response) {
    {
      "page":1,
      "results":[
        {
          "poster_path":"/WLQN5aiQG8wc9SeKwixW7pAR8K.jpg",
          "adult":false,
          "overview":"The quiet life of a terrier named Max is upended when his owner takes in Duke, a stray whom Max instantly dislikes.",
          "release_date":"2016-06-18",
          "genre_ids":[
            12,
            16,
            35,
            10751
          ],
          "id":328111,
          "original_title":"The Secret Life of Pets",
          "original_language":"en",
          "title":"The Secret Life of Pets",
          "backdrop_path":"/lubzBMQLLmG88CLQ4F3TxZr2Q7N.jpg",
          "popularity":134.355279,
          "vote_count":2174,
          "video":false,
          "vote_average":5.7
        }
      ],
      "total_results":298965,
      "total_pages":14949
    }
  }

  describe '.save_movies' do
    it 'saves movie_api movie results to database' do
      movies = [response[:results][0].stringify_keys]

      expect {
        Movie.save_movies(movies)
      }.to change(Watchable, :count).by 1
    end

    it 'updates a movie if it already exists in the database' do
      movies = [response[:results][0].stringify_keys]
      Movie.save_movies(movies)

      expect {
        Movie.save_movies(movies)
      }.not_to change(Watchable, :count)
    end
  end

  describe '.add_third_party_sources' do
    let(:json) { JSON.parse(File.read("vendor/sample_guidebox_responses/sample_movie_data_2.json")) }
    let(:id) { 602 }

    it 'updates a movie with third party url data' do
      Watchable.create(tmdb_type: "movie", tmdb_id: 602, title: "Independence Day")

      expect(Movie.add_third_party_sources(id, json).itunes).to eq "https:\/\/itunes.apple.com\/us\/movie\/independence-day\/id272967721?uo=4&at=10laHb"
    end
  end

end
