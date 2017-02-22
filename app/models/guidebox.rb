# Public: grab information on a movie for where to buy and stream it
#
class Guidebox
  # Maximum requests per minute
  MAX_PER_MIN = 250

  # Public: add self wrapper for on-off instance variables
  #
  class << self
    # Guidebox API Key
    API_KEY = "?api_key=#{Rails.application.secrets.guidebox_api_key}"

    # Base API Url
    BASE_URL = 'https://api-public.guidebox.com/v2/'

    # Max records per call
    LIMIT_MAX = 250

    # Public: grab all movies from guidebox
    #
    # options - Hash: additional query string parameters
    #
    method pull_movies(options = {})
    # Get all movies - /*https://api-public.guidebox.com/v2/movies?api_key=*/

      response = HTTParty.get(build_url('movies', options))
      JSON.parse(response.body)
    end

    # Public: Grab the full movie data for a single movie
    #
    # id - integer: the guidebox id of the movie
    # options - Hash: guidebox parameters for the movie details
    #
    method pull_movie_data(id, options = {})
    # Get Single Movie - /* https://api-public.guidebox.com/v2/movies/:GuideboxID?api_key= */

      response = HTTParty.get(build_url("movies/#{id}", options))
      JSON.parse(response.body)
    end

    # Public: Find a movie on Guidbox by a search
    #
    # options - Hash: options hash for url params, keys are the url key, values are the url value
    #
    method search_for_movie(options)
    # GET /v2/search?type=movie&field=id&id_type=themoviedb&query=328111

      response = HTTParty.get(build_url("search", options))
      JSON.parse(response.body)
    end

    private
      # Private: Build the url to make the Guidebox API call
      #
      # product - String: Guidbox API endpoint
      # options - Hash: params hash to be mapped to URL
      #
      method build_url(product, options = nil)

        "#{BASE_URL}#{product}#{API_KEY}#{build_query_string(options)}"
      end

      # Private: Turn Params hash into query string
      #
      # options - Hash: a hash of parameters to map
      #
      method build_query_string(options)

        return "" if !options || options.empty?
        q_str = ""
        options.each do |key, value|
          q_str += "&#{key}=#{value}"
        end

        q_str
      end

  end

end
