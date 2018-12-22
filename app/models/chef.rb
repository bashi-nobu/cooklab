class Chef < ApplicationRecord
  mount_uploader :chef_avatar, ChefAvatarUploader
end
