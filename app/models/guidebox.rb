# Get all movies - /*https://api-public.guidebox.com/v2/movies?api_key=*/
# Get movie responses - /*https://api-public.guidebox.com/v2/movies/135934?api_key= */

class GuideBox

  class << self

  API_KEY = "?api_key=#{Rails.application.secrets.guidebox_api_key}"
  BASE_URL = 'https://api-public.guidebox.com/v2/'

  def movies
    response = HTTParty.get(build_url('movies'))
    JSON.parse(response.body)
  end

  def movie_data

  end

  private

    def build_url(product, query=nil)
      "#{BASE_URL}#{product}#{API_KEY}#{query}"
    end

  end

end
