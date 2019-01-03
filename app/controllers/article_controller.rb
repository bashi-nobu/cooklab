class ArticleController < ApplicationController
  before_action :make_like_article_list
  before_action :get_article_genre

  def index
    @newest_article = Article.all.order(id: "desc").limit(1)[0]
    @articles = Article.where.not(id: @newest_article.id).page(params[:page]).per(10)
  end

  def show
    @article = Article.find(params[:id])
  end

  def genre_search
    @articles = Article.all.page(params[:page]).per(10)
    @search_path = '/article/genre_search'
    @search_patarn = 'genre'
    @search_word = params_permit_search_select[:genre]
    get_genre_search_results(@search_word)
  end

  def keyword_search
    @articles = Article.all.page(params[:page]).per(10)
  end

  private

  def get_genre_search_results(search_word)
    @articles = Article.tagged_with(search_word).page(params[:page]).per(10)
  end

  def get_article_genre
    @genre_tags = Article.tags_on(:tags)
  end

  def make_like_article_list
    @like_articles = Article.all.limit(5)
  end

  def params_permit_search
    params.permit(:search_word, :suggest_patarn)
  end

  def params_permit_search_select
    params.permit(:genre)
  end
end
