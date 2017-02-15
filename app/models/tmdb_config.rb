class TMDBConfig < ApplicationRecord

  def self.get
    if first.nil? || first.updated_at < 3.days.ago
      response = HTTParty.get(base_url)
      if first.nil? || response["images"]["base_url"] != first.url
        ActiveRecord::Base.connection.execute("DELETE FROM tmdb_configs")
        arr = [
          response["images"]["backdrop_sizes"],
          response["images"]["logo_sizes"],
          response["images"]["poster_sizes"],
          response["images"]["profile_sizes"],
          response["images"]["still_sizes"]
        ]
        arr.flatten!
        arr.uniq!
        arr.sort!
        create(
               url: response["images"]["base_url"],
               secure_url: response["images"]["secure_base_url"],
               sizes: arr
              )
      end
    end

    first
  end

  def self.api_key
    "?api_key=#{Rails.application.secrets.tmdb_key_v3}"
  end

  def self.base_url
    "https://api.themoviedb.org/3/configuration#{api_key}"
  end

end
