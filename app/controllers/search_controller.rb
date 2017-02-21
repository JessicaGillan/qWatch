class SearchController < ApplicationController
  def index
    terms = params[:search]
    strict = params[:strict] != "false" ? true : false
    render json: Watchable.title_search(terms, strict)
  end
end
