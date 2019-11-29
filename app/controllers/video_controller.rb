class VideoController < ApplicationController
  def show
    @video = Video.find(params[:id])
    @chefs = [@video.series.chef]
    @recommend_videos = Video.recommend(@video.id)
    @series_videos = Video.where(series: @video.series).includes(:charges).order("video_order")
    @current_user_like_count = VideoLike.where(user_id: current_user.id).length if user_signed_in?
  end

  def search
    @order_patarn = params[:order_patarn]
    @search_word = params[:search_word] if params[:search_word].present?
    @chef_id = params[:search_chef_id] if params[:search_chef_id] != [""]
    @chef_name = params[:search_chef_name].map { |c| c }.join(',') if params[:search_chef_name].present?
    @genre_name = check_genre_name_type(params[:search_genre_name])
    @series_title = params[:search_series_title]
    @series_id = params[:search_series_id] if params[:search_series_id] != [""]
    @search_patarn = 'keyword_search'
    q = make_search_query(@search_word, @genre_name)
    make_search_result_data_order_new(q.result(distinct: true).order("created_at desc")) if @order_patarn == 'new'
    make_search_result_data_order_like(q.result(distinct: true).order("created_at desc")) if @order_patarn == 'like'
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

  # def make_suggest
  #   @search_patarn = params[:search_patarn]
  #   keyword_suggest unless @search_patarn == 'chef-search'
  #   keyword_suggest_chef if @search_patarn == 'chef-search'
  # end

  private

  def get_video_of_search_chef_order_new(series)
    @videos = Video.where(series: series).order("created_at desc").page(params[:page]).per(10)
  end

  def get_video_of_search_chef_order_like(series)
    series_id_list = series.map(&:id)
    videos = Video.where(series: series_id_list).order("created_at desc")
    @videos = make_search_result_like_video_list(videos)
  end

  def get_keyword_search_chef_results(search_word)
    if search_word.present?
      query = make_chef_search_query(search_word)
      q = Chef.ransack(query)
      chef_ids = q.result(distinct: true).pluck(:id)
      @chefs = Chef.includes(series: [:videos]).where(id: chef_ids).where.not(videos: { id: nil }).page(params[:page]).per(10) if search_word.present?
    else
      @chefs = Chef.all.includes(series: [:videos]).order("created_at desc").page(params[:page]).per(10)
    end
  end

  def make_chef_search_query(search_word)
    query = {}
    query[:groupings] = []
    search_word.split(/[ 　]/).each_with_index do |word, i|
      query[:groupings][i] = { name_or_introduction_or_phonetic_or_biography_or_tags_name_cont: word }
    end
    query
  end

  def make_search_query(search_word, genre_name)
    query = {}
    query[:groupings] = []
    search_word = '' if search_word.nil?
    search_word.split(/[ 　]/).each_with_index do |word, i|
      query[:groupings][i] = { title_or_introduction_or_commentary_or_tags_name_cont: word }
    end
    result = Video.ransack(query) if genre_name.nil? || genre_name.empty?
    result = Video.tagged_with(genre_name, any: true).ransack(query) if genre_name.present?
    result
  end

  def make_search_result_data_order_new(videos)
    videos = videos.joins(:series).where(series_id: @series_id).where("series.chef_id" => @chef_id) if @chef_id.present? && @series_id.present?
    videos = videos.joins(:series).where("series.chef_id" => @chef_id) if @chef_id.present? && @series_id.nil?
    videos = videos.joins(:series).where(series_id: @series_id) if @chef_id.nil? && @series_id.present?
    videos = videos.joins(:series) if @chef_id.nil? && @series_id.nil?
    @videos = videos.page(params[:page]).per(10)
  end

  def make_search_result_data_order_like(videos)
    videos = videos.order("like_count desc").joins(:series).where(series_id: @series_id).where("series.chef_id" => @chef_id) if @chef_id.present? && @series_id.present?
    videos = videos.order("like_count desc").joins(:series).where("series.chef_id" => @chef_id) if @chef_id.present? && @series_id.nil?
    videos = videos.order("like_count desc").joins(:series).where(series_id: @series_id) if @chef_id.nil? && @series_id.present?
    videos = videos.order("like_count desc").joins(:series) if @chef_id.nil? && @series_id.nil?
    @videos = videos.page(params[:page]).per(10)
  end

  def make_search_result_like_video_list(search_hit_list)
    search_hit_video_id_list = search_hit_list.map(&:id)
    Video.where(id: search_hit_video_id_list).order("like_count desc").includes(:series).page(params[:page]).per(10)
  end

  def get_genre_search_results_order_new(search_word)
    @videos = if search_word.present?
                Video.tagged_with(search_word).order("created_at desc").includes(:series).page(params[:page]).per(10)
              else
                Video.all.order("created_at desc").page(params[:page]).per(10)
              end
  end

  def get_genre_search_results_order_like(search_word)
    videos = Video.tagged_with(search_word).order("created_at desc")
    @videos = make_search_result_like_video_list(videos)
  end

  def get_chef_genre_search_results(search_word)
    chef_ids = Chef.tagged_with(search_word).pluck(:id)
    @chefs = Chef.includes(series: [:videos]).where(id: chef_ids).where.not(videos: { id: nil }).page(params[:page]).per(10)
  end

  # def keyword_suggest
  #   @suggests_series = Series.where('title LIKE(?)', "%#{ params_permit_search[:search_word] }%")
  #   video_tag_list = Video.tags_on(:tags).map(&:name)
  #   @suggests_genre = video_tag_list.map { |v| v if v.include?(params_permit_search[:search_word]) }
  #   respond_to do |format|
  #     format.html
  #     format.json
  #   end
  # end

  # def keyword_suggest_chef
  #   chef_special_genre_tag_list = Chef.tags_on(:tags).map(&:name)
  #   @suggests_chef_genre = chef_special_genre_tag_list.map { |c| c if c.include?(params_permit_search[:search_word]) }
  #   respond_to do |format|
  #     format.html
  #     format.json
  #   end
  # end

  def check_genre_name_type(genre_name)
    genre_name = ["#{genre_name}"] unless genre_name.instance_of?(Array)
    genre_name = nil if genre_name == [""]
    genre_name
  end

  def params_permit_search
    params.permit(:search_word, :suggest_patarn)
  end

  def params_permit_search_select
    params.permit(:genre)
  end
end
