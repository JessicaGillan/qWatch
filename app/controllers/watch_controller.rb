class WatchController < ApplicationController
  def index
    render json: Watchable.all
  end

  def show
    watch = Watchable.find_by(id: params[:id])
    watch.full_details
    render json: watch
  end
end
