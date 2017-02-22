# Public: API controller for previously viewed items
#
class ViewingsController < ApplicationController
  # only signed in users have viewing histories
  before_action :authenticate_user!

  # create a new recent view
  def create
    # Note: until the guidebox api clears, view tracking is currently only set for Movies

    # find the movie in question
    viewed_item = Watchable.find_by(tmdb_id: params[:watch_id], tmdb_type: 'movie')

    # if the item is found, and they haven't already viewed it before
    # TODO: discuss multiple viewing of the same title
    if viewed_item && !(current_user.viewed_items.include? viewed_item)

      # associate the new viewed movie
      current_user.viewed_items << viewed_item

      # return the current time, the title, and the TMDB info
      render json: { viewed_at: Time.now, title: viewed_item.title,
                     tmdb_id: viewed_item.tmdb_id, tmdb_type: viewed_item.tmdb_type }
    end
  end

  def index
    # if trying to get the friends activity:
    if params[:friends_viewings]
      @friends_viewings = current_user.friends_viewings

      render json: @friends_viewings.to_json

    # otherwise show the user's history
    else
      @viewed_items = current_user.viewed_items_slim

      render json: @viewed_items.to_json
    end
  end
end
