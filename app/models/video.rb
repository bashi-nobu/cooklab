class Video < ApplicationRecord
  belongs_to :series
  mount_uploader :thumbnail, VideoThumbnailUploader
  with_options presence: true do
    validates :title
    validates :video_url
    validates :introduction
    validates :commentary
    validates :video_order
    validates :thumbnail
    validates :series_id
  end

  def self.updateDuplicateVideoOrderSomeSeries(seriesId, crudPatarn, oldVideoOrder, newVideoOrder)
    if crudPatarn == 'edit' && oldVideoOrder < newVideoOrder
      Video.where('video_order > ?', oldVideoOrder).where('video_order <= ?', newVideoOrder).where(series_id: seriesId).update_all("video_order = video_order - 1")
    else
      Video.where( 'video_order >= ?', newVideoOrder).where(series_id: seriesId).update_all("video_order = video_order + 1")
    end
  end
  def self.updateDuplicateVideoOrderAnotherSeries(newSeriesId, oldSeriesId, oldVideoOrder, newVideoOrder)
    Video.where( 'video_order > ?', oldVideoOrder).where(series_id: oldSeriesId).update_all("video_order = video_order - 1")
    Video.where( 'video_order >= ?', newVideoOrder).where(series_id: newSeriesId).update_all("video_order = video_order + 1")
  end
end
