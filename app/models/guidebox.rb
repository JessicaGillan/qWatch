# Get all movies - /*https://api-public.guidebox.com/v2/movies?api_key=*/
# Get movie responses - /*https://api-public.guidebox.com/v2/movies/135934?api_key= */

class Guidebox

  class << self

  API_KEY = "?api_key=#{Rails.application.secrets.guidebox_api_key}"
  BASE_URL = 'https://api-public.guidebox.com/v2/'

  def pull_movies
    response = HTTParty.get(build_url('movies'))
    JSON.parse(response.body)["results"]
  end

  def movies
    @movies = pull_movies.each do |movie|
      watch = Watchable.find_by(gb_id: movie["id"], gb_type: "movie")
      # if watch
      #   watch.update(title: movie["title"], {poster_attributes: { thumbnail: movie["poster_120x171"], medium: movie["poster_240x342"], large: movie["poster_400x570"] }})
      # else
      #   Watchable.create(gb_id: movie["id"], gb_type: "movie", title: movie["title"], {poster_attributes: { thumbnail: movie["poster_120x171"], medium: movie["poster_240x342"], large: movie["poster_400x570"] }})
      # end
    end
  end

  private

    def build_url(product, query=nil)
      "#{BASE_URL}#{product}#{API_KEY}#{query}"
    end

  end

end
