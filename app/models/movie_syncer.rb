class MovieSyncer
  class << self

    def movie_api
      TMDB
    end

    def url_api
      Guidebox
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

        set_pages(response["total_pages"], response["page"])

        Movie.save_movies(response["results"])

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

      movie_data = url_api.pull_movie_data(response["id"])
      return false unless movie_data["id"]

      Movie.add_third_party_sources(tmdb_id, movie_data)
    end

    private

      def set_pages(total_pages, page)
        @total_pages = @total_pages || total_pages

        if page
          @pages_retrieved = page
        else
          @total_pages = @pages_retrieved
        end
      end

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
