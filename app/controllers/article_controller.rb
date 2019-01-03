class ArticleController < ApplicationController
  before_action :make_like_article_list

  def index
    @newest_article = Article.all.order(id: "desc").limit(1)[0]
    @articles = Article.where.not(id: @newest_article.id).page(params[:page]).per(10)
  end

  def show
    @article = Article.find(params[:id])
  end

  def genre_search
    @articles = Article.all.page(params[:page]).per(10)
  end

  def keyword_search
    @articles = Article.all.page(params[:page]).per(10)
  end

  private

  def make_like_article_list
    @like_articles = Article.all.limit(5)
  end
end
