class Chef < ApplicationRecord
  has_many :series, dependent: :destroy
  acts_as_taggable_on :tags
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

  def self.tag_count(tags)
    Chef.tagged_with(tags, any: true).count(:all)
  end
end
