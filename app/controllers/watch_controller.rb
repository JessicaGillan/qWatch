class WatchController < ApplicationController
  def index
    watch = Watchable.order(id: :asc)
    watch = watch.limit(params[:limit].to_i) if(params[:limit])
    if(params[:limit] && params[:page])
      last = params[:page].to_i * params[:limit].to_i
      first = last - params[:limit].to_i + 1
      watch = watch.where('id BETWEEN :start AND :end', {start: first, end: last} )
    end
    render json: watch.all
  end

  def show
    puts params
    watch = Watchable.find_by(tmdb_id: params[:id], tmdb_type: params[:type])
    watch.full_details
    render json: watch
  end

end
