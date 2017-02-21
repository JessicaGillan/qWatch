class ViewingsController < ApplicationController
  before_action :authenticate_user!

  def create
    viewed_item = Watchable.find(params[:watch_id])

    if current_user.viewed_items << viewed_item
      render json: viewed_item
    end
  end

  def index
    if params[:friends_viewings]
      @friends_viewings = current_user.friends_viewings

      render json: @friends_viewings.to_json
    else
      @viewings = current_user.viewings

      render json: @viewings.to_json(include: [viewed: { only: [:title, :tmdb_id] }])
    end
  end
end
