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
    get_genre_search_results(@search_word)
  end

  def keyword_search
    @search_path = '/video/keyword_search'
    @search_word = params_permit_search[:search_word] if params_permit_search[:search_word].present?
    @search_patarn = params_permit_search[:suggest_patarn]
    get_keyword_search_results(@search_word) if @search_patarn.blank?
    get_series_search_results(@search_word) if @search_patarn == 'series'
    get_genre_search_results(@search_word) if @search_patarn == 'genre'
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
    get_video_of_search_chef(@chef.series)
  end

  def make_suggest
    @search_patarn = params[:search_patarn]
    keyword_suggest unless @search_patarn == 'chef-search'
    keyword_suggest_chef if @search_patarn == 'chef-search'
  end

  private

  def get_keyword_search_results(search_word)
    query = make_video_search_query(search_word) if search_word.present?
    q = Video.ransack(query)
    @videos = q.result(distinct: true).includes(:series).page(params[:page]).per(10) if search_word.present?
  end

  def get_keyword_search_chef_results(search_word)
    query = make_chef_search_query(search_word) if search_word.present?
    q = Chef.ransack(query)
    @chefs = q.result(distinct: true).page(params[:page]).per(10) if search_word.present?
  end

  def make_video_search_query(search_word)
    query = {}
    query[:groupings] = []
    search_word.split(/[ 　]/).each_with_index do |word, i|
      query[:groupings][i] = { title_or_introduction_or_commentary_or_tags_name_cont: word }
    end
    query
  end

  def make_chef_search_query(search_word)
    query = {}
    query[:groupings] = []
    search_word.split(/[ 　]/).each_with_index do |word, i|
      query[:groupings][i] = { name_or_introduction_or_phonetic_or_biography_or_tags_name_cont: word }
    end
    query
  end

  def get_series_search_results(search_word)
    @videos = Series.find_by(title: search_word).videos.includes(:series).page(params[:page]).per(10)
  end

  def get_genre_search_results(search_word)
    @videos = Video.tagged_with(search_word).includes(:series).page(params[:page]).per(10)
  end

  def get_chef_genre_search_results(search_word)
    @chefs = Chef.tagged_with(search_word).page(params[:page]).per(10)
  end

  def get_video_of_search_chef(series)
    @videos = Video.where(series: series).page(params[:page]).per(10)
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
