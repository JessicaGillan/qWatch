class Movie
  class << self

    def services
      @services = @services || set_services
    end

    def save_movies(movies)
      movies.each do |movie|
        watch = Watchable.find_by(tmdb_id: movie["id"].to_i, tmdb_type: "movie")

        if watch
          watch.update(watchable_params(movie, "movie"))
        else
          Watchable.create(watchable_params(movie, "movie"))
        end
      end
    end

    def add_third_party_sources(tmdb_id, movie_data)
      watch = Watchable.find_by(tmdb_id: tmdb_id, tmdb_type: "movie")

      if watch
        watch.update(watchable_source_params(movie_data))
      end

      watch
    end

    private

      def services
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
          tmdb_id: result["id"].to_i,
          tmdb_type: type,
          title: result["title"],
          poster: result["poster_path"]
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

      # GUIDEBOX SPECIFIC
      def get_link_for(service, result)
        services[service].each do |source_info|
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

      # GUIDEBOX SPECIFIC
      def hulu_sources
        [
          source_obj("free_web_sources", "hulu_free"),
          source_obj("subscription_web_sources", "hulu_plus"),
          source_obj("subscription_web_sources", "hulu_with_showtime")
        ]
      end

      # GUIDEBOX SPECIFIC
      def amazon_sources
        [
          source_obj("free_web_sources", "amazon_prime_free"),
          source_obj("subscription_web_sources", "amazon_prime")
        ]
      end

      # GUIDEBOX SPECIFIC
      def xfinity_sources
        [
          source_obj("free_web_sources", "xfinity"),
          source_obj("tv_everywhere_web_sources", "xfinity_tveverywhere"),
          source_obj("purchase_web_sources", "xfinity_purchase")
        ]
      end
  end
end
