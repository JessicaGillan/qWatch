class Movie

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
        Guidebox.SERVICES[service].each do |source_info|
          result[source_info.type].each do |source_item|
            if source_item["source"] == source_info.name
              return source_item["link"]
            end
          end
        end
        ""
      end

      def self.source_obj(source, name)
        { type: source, name: name }
      end

      def self.hulu_sources
        [
          source_obj("free_web_sources", "hulu_free"),
          source_obj("subscription_web_sources", "hulu_plus"),
          source_obj("subscription_web_sources", "hulu_with_showtime")
        ]
      end

      def self.amazon_sources
        [
          source_obj("free_web_sources", "amazon_prime_free"),
          source_obj("subscription_web_sources", "amazon_prime")
        ]
      end

      def self.xfinity_sources
        [
          source_obj("free_web_sources", "xfinity"),
          source_obj("tv_everywhere_web_sources", "xfinity_tveverywhere"),
          source_obj("purchase_web_sources", "xfinity_purchase")
        ]
      end

end
