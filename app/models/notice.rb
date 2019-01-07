class Notice < ApplicationRecord
  with_options presence: true do
    validates :title
    validates :message
  end
end
