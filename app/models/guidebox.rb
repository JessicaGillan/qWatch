# Get all movies - /*https://api-public.guidebox.com/v2/movies?api_key=*/
# Get movie responses - /*https://api-public.guidebox.com/v2/movies/135934?api_key= */

class Guidebox

  API_KEY = "?api_key=#{Rails.application.secrets.guidebox_api_key}"
  BASE_URL = 'https://api-public.guidebox.com/v2/'
  LIMIT_MAX = 250
  SERVICES = {
    hulu:        hulu_sources,
    amazon:      amazon_sources,
    netflix:     source_obj("subscription_web_sources", "netflix"),
    xfinity:     xfinity_sources,
    amazon_buy:  [source_obj("purchase_web_sources", "amazon_buy")],
    google_play: [source_obj("purchase_web_sources", "google_play")],
    itunes:      [source_obj("purchase_web_sources", "itunes")]
  }

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

  def save_movie_data(id)
    movie = Guidebox.pull_movie_data(id)
    watch = Watchable.find_by(gb_id: movie["id"].to_i, gb_type: "movie")

    if watch
      watch.update(watchable_source_params(movie))
    end
  end

  # GET https://api-public.guidebox.com/v2/movies?api_key=
  def self.pull_movies(options = {})
    response = HTTParty.get(build_url('movies', options))
    json = JSON.parse(response.body)

    @total_num_movies = @total_num_movies || json["total_results"]

    json["results"]
  end

  # GET https://api-public.guidebox.com/v2/movies/:id?api_key=
  def self.pull_movie_data(id, options = {})
    response = HTTParty.get(build_url("movies/#{id}", options))

    JSON.parse(response.body)
  end

  private

    def watchable_params(result, type)
      {
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

    def watchable_source_params(result)
      {
        hulu:        get_link_for :hulu,
        amazon:      get_link_for :amazon,
        netflix:     get_link_for :netflix,
        xfinity:     get_link_for :xfinity,
        amazon_buy:  get_link_for :amazon_buy,
        google_play: get_link_for :google_play,
        itunes:      get_link_for :itunes
      }
    end

    def get_link_for(service)
    end

    def source_obj(source, name)
      { type: source, name: name }
    end

    def hulu_sources
      [
        source_obj("free_web_sources", "hulu_free"),
        source_obj("subscription_web_sources", "hulu_plus"),
        source_obj("subscription_web_sources", "hulu_with_showtime")
      ]
    end

    def amazon_sources
      [
        source_obj("free_web_sources", "amazon_prime_free"),
        source_obj("subscription_web_sources", "amazon_prime")
      ]
    end

    def xfinity_sources
      [
        source_obj("free_web_sources", "xfinity"),
        source_obj("tv_everywhere_web_sources", "xfinity_tveverywhere"),
        source_obj("purchase_web_sources", "xfinity_purchase")
      ]
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
