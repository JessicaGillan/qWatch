class WatchablesController < ApplicationController

  #
  def show
    @watchable = Watchable.find_by(id: params[:id])

    respond_to do |format|
      format.json { render json: @watchable }
    end
  end
end
