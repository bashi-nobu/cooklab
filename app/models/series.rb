class Series < ApplicationRecord
  belongs_to :chef
  has_many :videos
end
