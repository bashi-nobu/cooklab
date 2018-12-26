class Series < ApplicationRecord
  belongs_to :chef
  has_many :videos, dependent: :destroy
  mount_uploader :thumbnail, SeriesThumbnailUploader
  with_options presence: true do
    validates :title
    validates :chef_id
  end
end
