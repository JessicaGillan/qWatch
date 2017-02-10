class Movie

  def initialize
    @total_num_movies = nil
    @num_retrieved = 0
    @services = set_services
  end

  # DO NOT CALL UNLESS INTEND TO UPDATE ENTIRE DATABASE
  def save_all_movies
    while !@total_num_movies || @num_retrieved < @total_num_movies
      save_movies({ offset: @num_retrieved, limit: LIMIT_MAX })
      sleep((60 / Guidebox.MAX_PER_MIN) + 0.1)
    end
  end

  def save_movies(options = {})
    response = Guidebox.pull_movies(options)

    @total_num_movies = @total_num_movies || response["total_results"]
    @num_retrieved += response["results"].length

    response["results"].each do |movie|
      watch = Watchable.find_by(moviedb_id: movie["id"].to_i, moviedb_type: "movie")

      if watch
        watch.update(watchable_params(movie, "movie"))
      else
        Watchable.create(watchable_params(movie, "movie"))
      end
    end
  end

  # Save Url data for an array of watchables
  def save_movies_data(watchables)
    watchables.each do |movie|
      save_movie_data(movie.gb_id)
      sleep((60 / Guidebox.MAX_PER_MIN) + 0.1)
    end
  end

  def save_movie_data(guidebox_id)
    movie = Guidebox.pull_movie_data(guidebox_id)
    watch = Watchable.find_by(gb_id: movie["id"].to_i, gb_type: "movie")

    if watch
      watch.update(watchable_source_params(movie))
    end
  end

  private

      def set_services
        {
          hulu:        hulu_sources,
          amazon:      amazon_sources,
          netflix:     [source_obj("subscription_web_sources", "netflix")],
          xfinity:     xfinity_sources,
          amazon_buy:  [source_obj("purchase_web_sources", "amazon_buy")],
          google_play: [source_obj("purchase_web_sources", "google_play")],
          itunes:      [source_obj("purchase_web_sources", "itunes")]
        }
      end

      def watchable_params(result, type)
        {
          moviedb_id: result["id"],
          moviedb_type: type,
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
          hulu:        get_link_for(:hulu, result),
          amazon:      get_link_for(:amazon, result),
          netflix:     get_link_for(:netflix, result),
          xfinity:     get_link_for(:xfinity, result),
          amazon_buy:  get_link_for(:amazon_buy, result),
          google_play: get_link_for(:google_play, result),
          itunes:      get_link_for(:itunes, result)
        }
      end

      def get_link_for(service, result)
        @services[service].each do |source_info|
          result[source_info[:type]].each do |source_item|
            if source_item["source"] == source_info[:name]
              return source_item["link"]
            end
          end
        end
        ""
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

end
