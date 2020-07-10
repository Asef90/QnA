class SearchController < ApplicationController
  def index
    area = params[:area]
    @matches = area == "All" ?
                 (ThinkingSphinx.search ThinkingSphinx::Query.escape(params[:query])) :
                 (area.constantize.search ThinkingSphinx::Query.escape(params[:query]))
  end
end
