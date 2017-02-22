class ViewingsController < ApplicationController
  before_action :authenticate_user!

  def create
    viewed_item = Watchable.find_by(tmdb_id: params[:watch_id], tmdb_type: 'movie')

    # Note: the join table is set up for movies only
    if viewed_item && !(current_user.viewed_items.include? viewed_item)
      current_user.viewed_items << viewed_item
      render json: { viewed_at: Time.now, title: viewed_item.title,
                     tmdb_id: viewed_item.tmdb_id, tmdb_type: viewed_item.tmdb_type }
    end
  end

  def index
    if params[:friends_viewings]
      @friends_viewings = current_user.friends_viewings

      render json: @friends_viewings.to_json
    else
      @viewed_items = current_user.viewed_items_slim

      render json: @viewed_items.to_json
    end
  end
end
