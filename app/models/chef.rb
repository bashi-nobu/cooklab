class Chef < ApplicationRecord
  has_many :series, dependent: :destroy
  mount_uploader :chef_avatar, ChefAvatarUploader
  with_options presence: true do
    validates :name
    validates :phonetic
    validates :introduction
    validates :biography
    validates :chef_avatar
  end

  def self.chef_search(chef_search_name)
    Chef.where("name LIKE :search_name OR phonetic LIKE :search_name", search_name: "%#{chef_search_name}%")
  end
end
