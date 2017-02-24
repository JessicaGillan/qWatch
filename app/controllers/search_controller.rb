# Public: API controller for searching for a given title
#
class SearchController < ApplicationController

  def index
    # get the title to search for
    terms = params[:search]

    # if the strict param is set, only return exact matches
    strict = params[:strict] != "false" ? true : false

    # grab all matching titles
    render json: Watchable.title_search(terms, strict)
  end
end
