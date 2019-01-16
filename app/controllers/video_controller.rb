class VideoController < ApplicationController
  def show
    @video = Video.find(params[:id])
    @chefs = [@video.series.chef]
    @recommend_videos = Video.all.limit(10)
    @series_videos = Video.where(series: @video.series).includes(:charges).order("video_order")
  end

  def genre_search
    @genre_search_path = '/video/genre_search'
    @search_patarn = 'genre'
    @search_word = params_permit_search_select[:genre]
    @recommned_tags = Video.tags_on(:tags).order(taggings_count: 'desc').limit(10)
    @genre_tags = Video.tags_on(:tags).map(&:name)
    get_genre_search_results_order_new(@search_word) if params[:order] == 'new'
    get_genre_search_results_order_like(@search_word) if @search_word.present? && (params[:order] == 'like' || params[:order].nil?)
  end

  def keyword_search
    @search_path = '/video/keyword_search'
    @search_word = params_permit_search[:search_word] if params_permit_search[:search_word].present?
    @search_patarn = params_permit_search[:suggest_patarn]
    if @search_patarn.blank?
      get_keyword_search_results_order_new(@search_word) if  params[:order] == 'new'
      get_keyword_search_results_order_like(@search_word) if @search_word.present? && (params[:order] == 'like' || params[:order].nil?)
    elsif @search_patarn == 'series'
      get_series_search_results_order_new(@search_word) if  params[:order] == 'new'
      get_series_search_results_order_like(@search_word) if @search_word.present? && (params[:order] == 'like' || params[:order].nil?)
    elsif @search_patarn == 'genre'
      get_genre_search_results_order_new(@search_word) if params[:order] == 'new'
      get_genre_search_results_order_like(@search_word) if @search_word.present? && (params[:order] == 'like' || params[:order].nil?)
    end
  end

  def chef_search
    @search_word = params_permit_search[:search_word] if params_permit_search[:search_word].present?
    @recommend_tags = Chef.tags_on(:tags).order(taggings_count: 'desc').limit(20)
    @search_patarn = params_permit_search[:suggest_patarn]
    @search_path = '/video/chef_search'
    get_keyword_search_chef_results(@search_word) if @search_patarn.blank?
    get_chef_genre_search_results(@search_word) if @search_patarn == 'chef_genre'
  end

  def chef_search_video
    @chef = Chef.find(params[:chef_id])
    @recommend_tags = Chef.tags_on(:tags).order(taggings_count: 'desc').limit(20)
    @search_patarn = 'chef-video'
    @search_path = '/video/chef_search'
    get_video_of_search_chef_order_new(@chef.series) if params[:order] == 'new'
    get_video_of_search_chef_order_like(@chef.series) if params[:order] == 'like' || params[:order].nil?
  end

  def make_suggest
    @search_patarn = params[:search_patarn]
    keyword_suggest unless @search_patarn == 'chef-search'
    keyword_suggest_chef if @search_patarn == 'chef-search'
  end

  private

  def get_keyword_search_results_order_new(search_word)
    q = make_video_search_query(search_word)
    @videos = q.result(distinct: true).order("created_at desc").page(params[:page]).per(10)
  end

  def get_keyword_search_results_order_like(search_word)
    q = make_video_search_query(search_word)
    videos = q.result(distinct: true).order("created_at desc")
    @videos = make_search_result_like_video_list(videos)
  end

  def get_video_of_search_chef_order_new(series)
    @videos = Video.where(series: series).order("created_at desc").page(params[:page]).per(10)
  end

  def get_video_of_search_chef_order_like(series)
    series_id_list = series.map(&:id)
    videos = Video.where(series: series_id_list).order("created_at desc")
    @videos = make_search_result_like_video_list(videos)
  end

  def get_keyword_search_chef_results(search_word)
    query = make_chef_search_query(search_word) if search_word.present?
    q = Chef.ransack(query)
    chef_ids = q.result(distinct: true).pluck(:id)
    @chefs = Chef.includes(series:[:videos]).where(id: chef_ids).where.not(videos: { id: nil }).page(params[:page]).per(10) if search_word.present?
  end

  def make_video_search_query(search_word)
    query = {}
    query[:groupings] = []
    search_word.split(/[ 　]/).each_with_index do |word, i|
      query[:groupings][i] = { title_or_introduction_or_commentary_or_tags_name_cont: word }
    end
    Video.ransack(query)
  end

  def make_chef_search_query(search_word)
    query = {}
    query[:groupings] = []
    search_word.split(/[ 　]/).each_with_index do |word, i|
      query[:groupings][i] = { name_or_introduction_or_phonetic_or_biography_or_tags_name_cont: word }
    end
    query
  end

  def get_series_search_results_order_new(search_word)
    @videos = Series.find_by(title: search_word).videos.order("created_at desc").includes(:series).page(params[:page]).per(10)
  end

  def get_series_search_results_order_like(search_word)
    videos = Series.find_by(title: search_word).videos.order("created_at desc")
    @videos = make_search_result_like_video_list(videos)
  end

  def make_search_result_like_video_list(search_hit_list)
    search_hit_video_id_list = search_hit_list.map(&:id)
    Video.where(id: search_hit_video_id_list).order("like_count desc").includes(:series).page(params[:page]).per(10)
  end

  def get_genre_search_results_order_new(search_word)
    @videos = Video.tagged_with(search_word).order("created_at desc").includes(:series).page(params[:page]).per(10)
  end

  def get_genre_search_results_order_like(search_word)
    videos = Video.tagged_with(search_word).order("created_at desc")
    @videos = make_search_result_like_video_list(videos)
  end

  def get_chef_genre_search_results(search_word)
    chef_ids = Chef.tagged_with(search_word).pluck(:id)
    @chefs = Chef.includes(series:[:videos]).where(id: chef_ids).where.not(videos: { id: nil }).page(params[:page]).per(10)
  end

  def keyword_suggest
    @suggests_series = Series.where('title LIKE(?)', "%#{ params_permit_search[:search_word] }%")
    video_tag_list = Video.tags_on(:tags).map(&:name)
    @suggests_genre = video_tag_list.map { |v| v if v.include?(params_permit_search[:search_word]) }
    respond_to do |format|
      format.html
      format.json
    end
  end

  def keyword_suggest_chef
    chef_special_genre_tag_list = Chef.tags_on(:tags).map(&:name)
    @suggests_chef_genre = chef_special_genre_tag_list.map { |c| c if c.include?(params_permit_search[:search_word]) }
    respond_to do |format|
      format.html
      format.json
    end
  end

  def params_permit_search
    params.permit(:search_word, :suggest_patarn)
  end

  def params_permit_search_select
    params.permit(:genre)
  end
end
