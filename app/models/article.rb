class Article < ApplicationRecord
  mount_uploader :thumbnail, ArticleThumbnailUploader
  acts_as_taggable_on :tags
  with_options presence: true do
    validates :title
    validates :contents
    validates :thumbnail
  end
end
