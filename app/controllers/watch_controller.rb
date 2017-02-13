class WatchController < ApplicationController
  def index
    render json: Watchable.all
  end

  def show
    watch = Watchable.find_by(id: params[:id])
    render json: watch.as_json(methods: [:full_details])
  end
end
