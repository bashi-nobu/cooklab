class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_one :userProfile, dependent: :destroy, inverse_of: :user

  accepts_nested_attributes_for :userProfile, update_only: true
end
