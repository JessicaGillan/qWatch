class TmdbConfigController < ApplicationController
  def index
    tmdb_config = TmdbConfig.get
    render json: tmdb_config
  end
end
