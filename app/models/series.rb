class Series < ApplicationRecord
  belongs_to :chef
  has_many :videos, dependent: :destroy
  mount_uploader :thumbnail, SeriesThumbnailUploader
end
