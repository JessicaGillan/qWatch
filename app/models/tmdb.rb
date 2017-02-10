class TMDB
  class << self

    API_KEY = "?api_key=#{Rails.application.secrets.tmdb_key_v3}"
    API_HEADER_KEY = Rails.application.secrets.tmdb_key_v4
    BASE_URL = 'https://api.themoviedb.org/3/discover/'
    MAX_PER_MIN = 240
    HEADERS = {"Authorization" => "Bearer #{API_HEADER_KEY}", "Content-Type": "application/json;charset=utf-8" }

    def pull_config
    end

    def pull_movies(options = {})
      response = HTTParty.get(build_url('movie', options), headers: HEADERS, debug_output: $stdout)
      JSON.parse(response.body)
    end

    private

    def build_url(product, options = nil, discover = nil)
      "#{BASE_URL}#{product}#{build_query_string(options)}#{DISCOVER_OPTIONS}"
    end

    # Format: &limit=10
    def build_query_string(options)
      q_str = "#{API_KEY}"

      return q_str if !options || options.empty?

      options.each do |key, value|
        q_str += "&#{key}=#{value}&"
      end

      q_str
    end

  end
end
