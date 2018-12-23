class VideoController < ApplicationController
  def show
    @chefs = Chef.where(id: 1)
  end

  def genre_search
  end

  def keyword_search
  end

  def chef_search
    @search_word = params_permit_chef_search[:search]
    @chefs = Chef.chef_search(@search_word).page(params[:page]).per(5)
    @recommend_chefs = Chef.select("name") #後ほど修正
    @search_patarn = 'chef-search'
    @search_path == '#'
  end

  def chef_search_video
    @chef = Chef.find(params[:chef_id])
    @recommend_chefs = Chef.select("name") #後ほど修正
    @search_patarn = 'chef-video'
    @search_path = '/video/chef_search'
  end

  private

  def params_permit_chef_search
    params.permit(:search)
  end
end
