class TopController < ApplicationController
  def index
    @new_videos = Video.all.order("created_at desc").limit(5)
    @like_videos = Video.all.order("like_count desc").limit(5)
    @new_articles = Article.all.order("created_at desc").limit(5)
    @magazine_address_check = MagazineAddress.register_check(current_user)
  end

end
