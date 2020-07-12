class SearchController < ApplicationController
  def index
    area = params[:area]
    query = ThinkingSphinx::Query.escape(params[:query])
    @matches = area == "All" ? ThinkingSphinx.search(query) : area.constantize.search(query)
  end
end
