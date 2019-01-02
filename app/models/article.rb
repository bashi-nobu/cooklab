class Article < ApplicationRecord
  mount_uploader :thumbnail, ArticleThumbnailUploader
end
