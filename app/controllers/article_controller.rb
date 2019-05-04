class ArticleController < ApplicationController
  before_action :make_recommend_like_article_list
  before_action :make_article_genre_list

  def index
    @newest_article = Article.all.order(id: "desc").limit(1)[0]
    @articles = Article.where.not(id: @newest_article.id).order("created_at desc").page(params[:page]).per(10) if params[:order] == 'new' || params[:order].nil?
    @articles = make_all_like_article_list if params[:order] == 'like'
    @search_path = '/article/keyword_search'
  end

  def show
    @article = Article.find(params[:id])
    @search_path = '/article/keyword_search'
    @current_user_like_count = ArticleLike.where(user_id: current_user.id).length  if user_signed_in?
  end

  def genre_search
    @genre_search_path = '/article/genre_search'
    @search_path = '/article/keyword_search'
    @search_patarn = 'genre'
    @search_word = params_permit_search_select[:genre]
    get_genre_search_results_order_new(@search_word) if params[:order] == 'new'
    get_genre_search_results_order_like(@search_word) if @search_word.present? && (params[:order] == 'like' || params[:order].nil?)
  end

  def keyword_search
    @search_patarn = 'keyword'
    @search_word = params_permit_search[:search_word] if params_permit_search[:search_word].present?
    get_keyword_search_results_order_new(@search_word) if  params[:order] == 'new'
    get_keyword_search_results_order_like(@search_word) if @search_word.present? && (params[:order] == 'like' || params[:order].nil?)
  end

  private

  def make_recommend_like_article_list
    @like_articles = Article.all.order("like_count desc").limit(5)
  end

  def make_search_result_like_article_list(search_hit_list)
    search_hit_article_id_list = search_hit_list.map(&:id)
    Article.where(id: search_hit_article_id_list).order("like_count desc").page(params[:page]).per(10)
  end

  def make_all_like_article_list
    Article.all.order("like_count desc").page(params[:page]).per(10)
  end

  def get_keyword_search_results_order_new(search_word)
    q = make_article_search_query(search_word)
    @articles = q.result(distinct: true).order("created_at desc").page(params[:page]).per(10)
  end

  def get_keyword_search_results_order_like(search_word)
    q = make_article_search_query(search_word)
    articles = q.result(distinct: true).order("created_at desc")
    @articles = make_search_result_like_article_list(articles)
  end

  def make_article_search_query(search_word)
    query = {}
    query[:groupings] = []
    search_word.split(/[ 　]/).each_with_index do |word, i|
      query[:groupings][i] = { title_or_contents_or_tags_name_cont: word }
    end
    Article.ransack(query)
  end

  def get_genre_search_results_order_new(search_word)
    @articles = Article.tagged_with(search_word).order("created_at desc").page(params[:page]).per(10)
  end

  def get_genre_search_results_order_like(search_word)
    articles = Article.tagged_with(search_word).order("created_at desc")
    @articles = make_search_result_like_article_list(articles)
  end

  def make_article_genre_list
    @genre_tags = Article.tags_on(:tags)
  end

  def params_permit_search
    params.permit(:search_word, :suggest_patarn)
  end

  def params_permit_search_select
    params.permit(:genre)
  end
end
