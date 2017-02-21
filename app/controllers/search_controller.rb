class SearchController < ApplicationController
  def index
    terms = params[:search]
    strict = false
    strict = true if(params[:strict] != "false")
    render json: Watchable.title_search(terms, strict)
  end
end
