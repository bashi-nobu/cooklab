class TopController < ApplicationController
  def index
    @new_videos = Video.all.order("created_at desc").limit(5)
    @like_videos = make_like_video_list
    @new_articles = Article.all.order("created_at desc").limit(5)
  end

  private

  def make_like_video_list
    like_videos = VideoLike.group(:video_id).order('count(video_id) desc').limit(5).pluck(:video_id)
    like_video_list = []
    like_videos.each do |lv|
      like_video_list << Video.find(lv)
    end
    like_video_list
  end
end
