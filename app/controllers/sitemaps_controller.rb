class SitemapsController < ApplicationController
  def index
    @domain = "#{request.protocol}#{request.host}"
    @videos = Video.all
    @articles = Article.all
  end
end
