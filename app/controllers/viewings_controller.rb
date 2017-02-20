class ViewingsController < ApplicationController
  before_action :authenticate_user!

  def create
    viewed_item = Watchable.find(params[:watch_id])

    if current_user.viewed_items << viewed_item
      render json: viewed_item
    end
  end

  def index
    render json: current_user.viewed_items
  end
end
