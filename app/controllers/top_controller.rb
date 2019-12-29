class TopController < ApplicationController
  before_action :make_top_slide_list

  def index
    @new_videos = Video.all.order("created_at desc").limit(6)
    @new_articles = Article.all.order("created_at desc").limit(6)
    @magazine_address_check = MagazineAddress.register_check(current_user)
    @french_like_videos = Video.tagged_with("フランス料理", any: true).order("like_count desc").limit(6)
    @japanese_like_videos = Video.tagged_with("日本料理", any: true).order("like_count desc").limit(6)
  end

  private

  def make_top_slide_list
  	@article_top_slides = Article.where(top_slide: true).limit(3)
  	@video_top_slides = Video.all.order("created_at desc").limit(3)
  end

end
