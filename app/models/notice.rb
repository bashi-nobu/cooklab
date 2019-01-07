class Notice < ApplicationRecord
  has_many :users, through: :noticeUsers
  has_many :noticeUsers
  with_options presence: true do
    validates :title
    validates :message
  end
end
