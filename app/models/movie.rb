class Movie
  class << self

    def movie_api
      TMDB
    end

    def url_api
      Guidebox
    end

    def services
      @services = @services || set_services
    end

    def setup
      @total_pages = nil
      @pages_retrieved = 0
    end

    def ddos_protect(max)
      sleep(((60 / max) * 10).ceil/10)
    end

    # DO NOT CALL UNLESS INTEND TO UPDATE ENTIRE DATABASE

    def populate_db_titles
      setup
      while !@total_pages || @pages_retrieved < @total_pages
        response = movie_api.pull_movies(set_discover)

        unless response["success"] || response["results"]
          puts "Request Error: #{response["status_message"]}, #{response["status_code"]}"
          break
        end

        save_movies(response)
        ddos_protect(movie_api::MAX_PER_MIN)
      end
    end

    # Save Url data for an array of watchables
    # Defaults to all Watchables in DB if not set
    def populate_watchables_data(watchables = nil)
      watchables = watchables || Watchable.all

      watchables.each do |movie|
        populate_watchable_data(movie.tmdb_id)
        ddos_protect(url_api::MAX_PER_MIN)
      end
    end

    def populate_watchable_data(tmdb_id)
      options = { type: "movie", field: 'id', id_type: 'themoviedb', query: tmdb_id }

      response = url_api.search_for_movie(options)
      return false unless response["themoviedb"] == tmdb_id

      movie = url_api.pull_movie_data(response["id"])
      return false unless movie["id"]

      watch = Watchable.find_by(tmdb_id: tmdb_id, tmdb_type: "movie")

      if watch
        watch.update(watchable_source_params(movie))
      end
    end

    private

      def set_discover
        {
          language: "en-US",
          sort_by: "popularity.desc",
          include_adult: false,
          include_video: false,
          page: @pages_retrieved + 1
        }
      end

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

      def save_movies(response)
        @total_pages = @total_pages || response["total_pages"]
        if response["page"]
          @pages_retrieved = response["page"]
        else
          @total_pages = @pages_retrieved
        end

        response["results"].each do |movie|
          watch = Watchable.find_by(tmdb_id: movie["id"].to_i, tmdb_type: "movie")

          if watch
            watch.update(watchable_params(movie, "movie"))
          else
            Watchable.create(watchable_params(movie, "movie"))
          end
        end
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

      # TODO: UPDATE THIS FOR MOVIE_DB, OR EDIT DATA RETURNED TO MATCH THIS
      def watchable_params(result, type)
        {
          tmdb_id: result["id"],
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
