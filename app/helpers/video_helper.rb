module VideoHelper
  def adjust_play_list_icon(series_video, play_video)
    if series_video.id == play_video.id
      fa_icon "play-circle"
    else
      fa_icon "film"
    end
  end

  def adust_created_at(created_at)
    created_at.to_s.dup.sub!(/\s.*/, "").tr!("-", "/")
  end

  def new_video_check(created_at)
    (Time.current - created_at).to_i < 1_296_000
  end
end
