# Get all movies - /*https://api-public.guidebox.com/v2/movies?api_key=*/
# Get movie responses - /*https://api-public.guidebox.com/v2/movies/135934?api_key= */

class Guidebox

  API_KEY = "?api_key=#{Rails.application.secrets.guidebox_api_key}"
  BASE_URL = 'https://api-public.guidebox.com/v2/'
  LIMIT_MAX = 250

  def initialize
    @total_num_movies = nil
    @num_retrieved = 0
  end

  # DO NOT CALL UNLESS INTEND TO UPDATE ENTIRE DATABASE
  def save_all_movies
    while @num_retrieved < @total_num_movies
      save_movies({ offset: @num_retrieved, limit: LIMIT_MAX })
    end
  end

  def save_movies(options = {})
    results = Guidebox.pull_movies(options)

    @num_retrieved += results.length

    results.each do |movie|
      watch = Watchable.find_by(gb_id: movie["id"].to_i, gb_type: "movie")

      if watch
        watch.update(watchable_params(movie, "movie"))
      else
        Watchable.create(watchable_params(movie, "movie"))
      end
    end
  end

  def self.pull_movies(options = {})
    response = HTTParty.get(build_url('movies', options))
    json = JSON.parse(response.body)

    @total_num_movies = @total_num_movies || json["total_results"]

    json["results"]
  end

  private

    def watchable_params(result, type)
      return {
        gb_id: result["id"],
        gb_type: type,
        title: result["title"],
        poster_attributes:
        {
          thumbnail: result["poster_120x171"],
          medium: result["poster_240x342"],
          large: result["poster_400x570"]
        }
      }
    end

    def self.build_url(product, options = nil)
      "#{BASE_URL}#{product}#{API_KEY}#{build_query_string(options)}"
    end

    # Format: &limit=10
    def self.build_query_string(options)
      return "" if !options || options.empty?

      q_str = ""
      options.each do |key, value|
        q_str += "&#{key}=#{value}"
      end

      q_str
    end

end
