# Get all movies - /*https://api-public.guidebox.com/v2/movies?api_key=*/
# Get movie responses - /*https://api-public.guidebox.com/v2/movies/135934?api_key= */

class Guidebox

  class << self

  API_KEY = "?api_key=#{Rails.application.secrets.guidebox_api_key}"
  BASE_URL = 'https://api-public.guidebox.com/v2/'
  LIMIT_MAX = 250
  MAX_PER_MIN = 250

  # GET https://api-public.guidebox.com/v2/movies?api_key=
  def pull_movies(options = {})
    response = HTTParty.get(build_url('movies', options))

    JSON.parse(response.body)
  end

  # GET https://api-public.guidebox.com/v2/movies/:id?api_key=
  def pull_movie_data(id, options = {})
    response = HTTParty.get(build_url("movies/#{id}", options))

    JSON.parse(response.body)
  end

  # GET /v2/search?type=movie&field=id&id_type=themoviedb&query=328111
  def search_for_movie(options)
    response = HTTParty.get(build_url("search", options))

    JSON.parse(response.body)
  end

  private

    def build_url(product, options = nil)
      "#{BASE_URL}#{product}#{API_KEY}#{build_query_string(options)}"
    end

    # Format: &limit=10
    def build_query_string(options)
      return "" if !options || options.empty?

      q_str = ""
      options.each do |key, value|
        q_str += "&#{key}=#{value}"
      end

      q_str
    end

  end

end
