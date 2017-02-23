# Public: DB model for movies table
#
class Movie

  # Public: self wrapper for privatization of class methods
  #
  class << self

    # Public: caching of services object
    #
    def services
      @services = @services || set_services
    end

    # Public: save or update movies from MovieSyncer
    #
    # movies - Array: Array of TMDB movies
    #
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

    # Public: add streaming information to a watchable
    #
    # tmdb_id - integer: TMDB DB primary key
    # movie_data - Hash: Hash of Movie information from Guidebox
    #
    def add_third_party_sources(tmdb_id, movie_data)

      watch = Watchable.find_by(tmdb_id: tmdb_id, tmdb_type: "movie")
      if watch
        watch.update(watchable_source_params(movie_data))
      end

      watch
    end

    private

      # Private: create a hash of supported services for a movie
      #
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

      # Private: strong params for saving a basic watchable
      #
      # result - JSON/Hash: TMDB Api call result
      # type - String: Movie or TV show
      #
      def watchable_params(result, type)

        {
        tmdb_id: result["id"].to_i,
        tmdb_type: type,
        title: result["title"],
        poster: result["poster_path"]
        }
      end

      # Private: Strong Params object for Watchable with full data
      #
      # result - Hash/JSON: result of Guidebox API call
      #
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
      # Private: grab the actual url for a given streaming service
      #
      # service - string: what service to grab
      # result - Hash/JSON: Guidebox API result
      #
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

      # Private: normalize available services from API
      #
      # source - string: type of streaming source
      # name - String: name of streaming/purchase site
      #
      def source_obj(source, name)
        { type: source, name: name }
      end

      # GUIDEBOX SPECIFIC
      # Private: Array wrapper for available hulu sources
      #
      def hulu_sources
        [
        source_obj("free_web_sources", "hulu_free"),
        source_obj("subscription_web_sources", "hulu_plus"),
        source_obj("subscription_web_sources", "hulu_with_showtime")
        ]
      end

      # GUIDEBOX SPECIFIC
      # Private: Array wrapper for available amazon sources
      #
      def amazon_sources
        [
        source_obj("free_web_sources", "amazon_prime_free"),
        source_obj("subscription_web_sources", "amazon_prime")
        ]
      end

      # GUIDEBOX SPECIFIC
      # Private: Array wrapper for available xfinity sources
      #
      def xfinity_sources
        [
        source_obj("free_web_sources", "xfinity"),
        source_obj("tv_everywhere_web_sources", "xfinity_tveverywhere"),
        source_obj("purchase_web_sources", "xfinity_purchase")
        ]
      end

  end

end
