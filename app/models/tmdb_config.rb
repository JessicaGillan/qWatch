# Public: grab TMDB API configuration and cache it for 72 hours
#
class TMDBConfig < ApplicationRecord

  # Public: Make an API call to themoviedb.com and grab the config
  #
  def self.get

    # if there are no rows, or the first row is older than 3 days grab the info from TMDB
    if first.nil? || first.updated_at < 72.hours.ago
      response = HTTParty.get(base_url)
      # if there are no rows, or the data has changed since the last call, clear DB and insert new data
      if first.nil? || response["images"]["base_url"] != first.url
        ActiveRecord::Base.connection.execute("DELETE FROM tmdb_configs")

        # create an array of the image data
        arr = [
          response["images"]["backdrop_sizes"],
          response["images"]["logo_sizes"],
          response["images"]["poster_sizes"],
          response["images"]["profile_sizes"],
          response["images"]["still_sizes"]
        ]

        # flatten the array of array and only keep unique values
        arr.flatten!
        arr.uniq!
        arr.sort!

        # insert the new row
        create(
          url: response["images"]["base_url"],
          secure_url: response["images"]["secure_base_url"],
          sizes: arr
        )
      end

    end

    # return the first row in the DB
    first
  end

  # Public: method wrapper for the TMDB api key
  #
  def self.api_key
    "?api_key=#{Rails.application.secrets.tmdb_key_v3}"
  end

  # Public: base domain for TMDB
  #
  def self.base_url
    "https://api.themoviedb.org/3/configuration#{api_key}"
  end

end
