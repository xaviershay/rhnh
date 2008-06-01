class SearchController < ApplicationController
  def show
    @posts = Post.search(@search_term = params[:q])
  end
end
