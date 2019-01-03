class TopController < ApplicationController
  def index
    @videos = Video.all.limit(10)
    @articles = Article.all.limit(10)
  end
end
