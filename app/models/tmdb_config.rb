class TmdbConfig < ApplicationRecord

  def self.get
    if first.nil? || first.updated_at < 3.days.ago
      response = HTTParty.get(base_url)
      if first.nil? || response["images"]["base_url"] != first.url
        destroy_all
        create(url: response["images"]["base_url"])
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
