class VideoLike < ApplicationRecord
  belongs_to :video, counter_cache: :like_count
  belongs_to :user
end
