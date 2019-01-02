class Video < ApplicationRecord
  belongs_to :series
  has_many :recipes, dependent: :destroy
  has_many :charges, dependent: :destroy
  has_many :users, through: :charges
  accepts_nested_attributes_for :recipes, allow_destroy: true
  mount_uploader :thumbnail, VideoThumbnailUploader
  acts_as_taggable_on :tags
  with_options presence: true do
    validates :title
    validates :video_url
    validates :introduction
    validates :commentary
    validates :video_order
    validates :thumbnail
    validates :series_id
  end

  def self.update_duplicate_video_order_some_series(series_id, crud_patarn, old_video_order, new_video_order)
    if crud_patarn == 'edit' && old_video_order < new_video_order
      Video.where('video_order > ?', old_video_order).where('video_order <= ?', new_video_order).where(series_id: series_id).find_each { |v| v.update(video_order: v.video_order - 1) }
    elsif crud_patarn == 'delete'
      Video.where('video_order > ?', old_video_order).where(series_id: series_id).find_each { |v| v.update(video_order: v.video_order - 1) }
    else
      Video.where('video_order >= ?', new_video_order).where(series_id: series_id).find_each { |v| v.update(video_order: v.video_order + 1) }
    end
  end

  def self.update_duplicate_video_order_another_series(new_series_id, old_series_id, old_video_order, new_video_order)
    Video.where('video_order > ?', old_video_order).where(series_id: old_series_id).find_each { |v| v.update(video_order: v.video_order - 1) }
    Video.where('video_order >= ?', new_video_order).where(series_id: new_series_id).find_each { |v| v.update(video_order: v.video_order + 1) }
  end

  def self.tag_count(tags)
    Video.tagged_with(tags, any: true).count(:all)
  end
end
