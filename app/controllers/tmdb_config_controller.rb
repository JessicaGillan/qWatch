# Public: API controller for returning TMDB api configurations
#
class TMDBConfigController < ApplicationController
  def index
    tmdb_config = TMDBConfig.get
    render json: tmdb_config
  end
end
