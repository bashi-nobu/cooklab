class Article < ApplicationRecord
  has_many :article_likes, dependent: :destroy
  mount_uploader :thumbnail, ArticleThumbnailUploader
  acts_as_taggable_on :tags
  with_options presence: true do
    validates :title
    validates :contents
    validates :thumbnail
  end

  def self.tag_count(tags)
    Article.tagged_with(tags, any: true).count(:all)
  end
end
