# Public: API controller for all watchables and individual watchables
#
class WatchController < ApplicationController
  def index
    # preset the order for watchables, but don't call server yet
    watch = Watchable.order(id: :asc)
    # limit to n items if limit param is sent
    watch = watch.limit(params[:limit].to_i) if(params[:limit])

    # pagination logic if both page and limit are sent
    # all watchables are continuous indexed (start at one, no gaps in numbers) and the model is reindexed as necessary
    if(params[:limit] && params[:page])
      # last item ID to retrieve
      last = params[:page].to_i * params[:limit].to_i
      # first item ID to retrieve
      first = last - params[:limit].to_i + 1
      # add where clause for items between first and last
      watch = watch.where('id BETWEEN :start AND :end', {start: first, end: last} )
    end

    # finally call the DB and render the response as JSON
    render json: watch.all
  end

  # get individual Movie/TV show
  def show
    # find polymorphic by indexed tmdb info
    # since primary key is reindexed for pagination, this key does not change
    watch = Watchable.find_by(tmdb_id: params[:id], tmdb_type: params[:type])
    # grab all details including guidebox info.
    # this will affect API limits
    watch.full_details
    render json: watch
  end

end
