# Public: API wrapper for themoviedb.org's discovery endpoint
#
class TMDB

  # Maximum Requests per minute
  MAX_PER_MIN = 240

  # Public: self wrapper for privatization of class methods
  #
  class << self

    # URI query param key
    API_KEY = "?api_key=#{Rails.application.secrets.tmdb_key_v3}"

    # API v4 Authentication Header
    API_HEADER_KEY = Rails.application.secrets.tmdb_key_v4

    # Constant URL section
    BASE_URL = 'https://api.themoviedb.org/3/discover/'

    # HTTP Headers to be added
    HEADERS = {"Authorization" => "Bearer #{API_HEADER_KEY}", "Content-Type": "application/json;charset=utf-8" }

    # Public: Make the HTTP call to TMDB to grab the most poopular movies
    #
    # options - Hash: http options hash for url query params
    #
    def pull_movies(options = {})
      response = HTTParty.get(build_url('movie', options), headers: HEADERS, debug_output: $stdout)
      JSON.parse(response.body)
    end

    private

      # Private: combine the three sections of the API url
      #
      # product - String: Movie or Tv Show
      # options - Hash: url query params hash
      #
      def build_url(product, options = nil)
        "#{BASE_URL}#{product}#{build_query_string(options)}"
      end

      # Private: convert hash of query params to string
      #
      # options - Hash: Hash of query parameters
      #
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
