class VideoLikesController < ApplicationController
  def create
    like = VideoLike.create(user_id: current_user.id, video_id: params[:video_id])
    @video = Video.find(params[:video_id])
  end

  def destroy
    like = VideoLike.find_by(user_id: current_user.id, video_id: params[:video_id])
    like.destroy
    @video = Video.find(params[:video_id])
  end
end
