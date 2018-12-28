class Recipe < ApplicationRecord
  belongs_to :video
  with_options presence: true do
    validates :food
    validates :amount
  end
end
