class VideoController < ApplicationController
  def show
    @video = Video.find(params[:id])
    @chefs = [@video.series.chef]
    @recommend_videos = Video.all.limit(10)
    @series_videos = Video.where(series: @video.series).order("video_order")
  end

  def genre_search
    @genre_tags = Video.tags_on(:tags).map { |t| ["#{ t.name } (#{ t.taggings_count })", t.name] }
    @videos = Video.all.page(params[:page]).per(10)
  end

  def keyword_search
    @videos = Video.all.page(params[:page]).per(10)
  end

  def chef_search
    @search_word = params_permit_search[:search]
    @chefs = Chef.chef_search(@search_word).page(params[:page]).per(10)
    @recommend_chefs = Chef.select("name") #後ほど修正
    @search_patarn = 'chef-search'
    @search_path == '#'
  end

  def chef_search_video
    @chef = Chef.find(params[:chef_id])
    @recommend_chefs = Chef.select("name") #後ほど修正
    @search_patarn = 'chef-video'
    @search_path = '/video/chef_search'
    series = @chef.series
    @videos = Video.where(series: series).page(params[:page]).per(10)
  end

  private

  def params_permit_search
    params.permit(:search)
  end
end
