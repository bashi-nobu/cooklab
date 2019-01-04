class ArticleController < ApplicationController
  before_action :make_like_article_list
  before_action :make_article_genre_list

  def index
    @newest_article = Article.all.order(id: "desc").limit(1)[0]
    @articles = Article.where.not(id: @newest_article.id).page(params[:page]).per(10)
    @search_path = '/article/keyword_search'
  end

  def show
    @article = Article.find(params[:id])
    @search_path = '/article/keyword_search'
  end

  def genre_search
    @articles = Article.all.page(params[:page]).per(10)
    @genre_search_path = '/article/genre_search'
    @search_path = '/article/keyword_search'
    @search_patarn = 'genre'
    @search_word = params_permit_search_select[:genre]
    get_genre_search_results(@search_word)
  end

  def keyword_search
    @search_word = params_permit_search[:search_word] if params_permit_search[:search_word].present?
    get_keyword_search_results(@search_word) if @search_patarn.blank?
  end

  private

  def get_keyword_search_results(search_word)
    query = make_article_search_query(search_word) if search_word.present?
    q = Article.ransack(query)
    @articles = q.result(distinct: true).page(params[:page]).per(10) if search_word.present?
  end

  def make_article_search_query(search_word)
    query = {}
    query[:groupings] = []
    search_word.split(/[ 　]/).each_with_index do |word, i|
      query[:groupings][i] = { title_or_contents_or_tags_name_cont: word }
    end
    query
  end

  def get_genre_search_results(search_word)
    @articles = Article.tagged_with(search_word).page(params[:page]).per(10)
  end

  def make_article_genre_list
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
