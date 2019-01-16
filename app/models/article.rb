class Article < ApplicationRecord
  has_many :article_likes, dependent: :destroy
  belongs_to :chef
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

  def like_user(user_id)
    article_likes.find_by(user_id: user_id)
  end
end
