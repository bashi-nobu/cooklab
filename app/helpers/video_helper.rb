module VideoHelper
  def adjust_play_list_icon(series_video, play_video)
    if series_video.id == play_video.id
      fa_icon "play-circle"
    else
      fa_icon "film"
    end
  end

  def new_video_check(created_at)
    (Time.current - created_at).to_i < 1_296_000
  end

  def video_charge_check(video)
    if video.price > 0
      Charge.where(user_id: current_user.id, video_id: video.id).count
    else
      1
    end
  end

  def article_author_check(tag)
    if tag.name == '記事専門'
      1
    else
      0
    end
  end
end
