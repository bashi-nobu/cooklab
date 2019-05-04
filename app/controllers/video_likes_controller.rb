class VideoLikesController < ApplicationController
  def create
    VideoLike.create(user_id: current_user.id, video_id: params[:video_id])
    @video = Video.find(params[:video_id])
    @current_user_like_count = VideoLike.where(user_id: current_user.id).length
  end

  def destroy
    like = VideoLike.find_by(user_id: current_user.id, video_id: params[:video_id])
    like.destroy
    @video = Video.find(params[:video_id])
    @current_user_like_count = VideoLike.where(user_id: current_user.id).length
  end
end

