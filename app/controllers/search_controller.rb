class SearchController < ApplicationController
  def index
    terms = params[:search]
    render json: Watchable.title_search(terms)
  end
end
