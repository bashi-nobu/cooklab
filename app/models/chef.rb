class Chef < ApplicationRecord
  has_many :serieses
  mount_uploader :chef_avatar, ChefAvatarUploader

  def self.chef_search(chef_search_name)
    Chef.where("name LIKE :search_name OR phonetic LIKE :search_name", search_name: "%#{chef_search_name}%")
  end
end
