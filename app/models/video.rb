class Video < ApplicationRecord
  belongs_to :series
  mount_uploader :thumbnail, VideoThumbnailUploader
end
