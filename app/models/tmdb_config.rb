class TmdbConfig < ApplicationRecord

  class << self

    API_KEY = "?api_key=#{Rails.application.secrets.tmdb_key_v3}"
    BASE_URL = "https://api.themoviedb.org/3/configuration#{API_KEY}"

    def get
      if first.nil? || first.updated_at < 3.days.ago
        response = HTTParty.get(BASE_URL)
        if response["images"]["base_url"] != first.url
          destroy_all
          create(url: response["images"]["base_url"])
        end
      end

      first.url
    end

  end

end
