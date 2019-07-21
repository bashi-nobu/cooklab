class MagazineAddress < ApplicationRecord
  belongs_to :user

  validates :zipcode, format: {with: /\A[0-9]{7}\z/}

  def self.register_check(user)
    MagazineAddress.find_by(user: user)
  end
end
