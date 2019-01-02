class Article < ApplicationRecord
  mount_uploader :thumbnail, ArticleThumbnailUploader
  with_options presence: true do
    validates :title
    validates :contents
    validates :thumbnail
  end
end
