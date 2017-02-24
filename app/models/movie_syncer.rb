# Public: Pull basic movie info and poster images from The Movie DB
#
class MovieSyncer

  # Public: self wrapper for privatization of class methods
  #
  class << self

    # Public: Method wrapper for TMDB class
    #
    def movie_api
      TMDB
    end

    # Public: method wrapper for Guidebox class
    #
    def url_api
      Guidebox
    end

    # Public: Delete cached movies from DB
    #
    def destroy_data
      # ActiveRecord::Base.connection.execute("DELETE FROM watchables")
    end

    # Public: setup variables for collecting movies from TMDB
    #
    def setup_population
      destroy_data
      reindex
      @total_pages = nil
      @pages_retrieved = 0
    end

    # Public: keep API calls from DDOSing themoviedb.com
    #
    # max - integer: maximum calls per minute
    #
    def ddos_protect(max)
      sleep(((60 / max) * 10).ceil/10)
    end

    # Public: grab all the most popular titles from TMDB
    # DO NOT CALL UNLESS INTENDING TO UPDATE ENTIRE DATABASE
    #
    def populate_db_titles

      setup_population
      while !@total_pages || @pages_retrieved < @total_pages
        response = movie_api.pull_movies(set_discover)
        unless response["success"] || response["results"]
          puts "Request Error: #{response["status_message"]}, #{response["status_code"]}"
          break
        end

        set_pages(response["total_pages"], response["page"])
        Movie.save_movies(response["results"])
        ddos_protect(movie_api::MAX_PER_MIN)
      end

    end

    # Public: reindex the watchables table for contiguous indexing and optimized pagination
    #
    def reindex
      Watchable.reindex
    end

    # Public: grab full information for individual movie including streaming sources
    #
    # watchables - Array<Watchable>: array of Watchable results
    #              Defaults to all Watchables in DB if not set
    #
    def populate_watchables_data(watchables = nil)

      watchables.each do |movie|
        populate_watchable_data(movie.tmdb_id)
        ddos_protect(url_api::MAX_PER_MIN)
      end

    end

    # Public: Grab Full movie data for a single movie
    #
    # tmdb_id - integer: TheMovieDB id
    #
    def populate_watchable_data(tmdb_id)

      options = { type: "movie", field: 'id', id_type: 'themoviedb', query: tmdb_id }
      response = url_api.search_for_movie(options)

      return false unless response["themoviedb"] == tmdb_id

      movie_data = url_api.pull_movie_data(response["id"])
      return false unless movie_data["id"]

      Movie.add_third_party_sources(tmdb_id, movie_data)
    end

    private

      # Private: track pagination variable for looping through TMDB API
      #
      # total_pages - integer: total pages to retrieve from TMDB
      # page - integer: current page of TMDB API calls
      #
      def set_pages(total_pages, page)

        @total_pages = @total_pages || total_pages
        if page
          @pages_retrieved = page
        else
          @total_pages = @pages_retrieved
        end

      end

      # Private: return the hash to build API uri string
      #
      def set_discover
        {
          language: "en-US",
          sort_by: "popularity.desc",
          include_adult: false,
          include_video: false,
          page: @pages_retrieved + 1
        }
      end

  end

end
