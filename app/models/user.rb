class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable
  has_one :userProfile, dependent: :destroy, inverse_of: :user
  accepts_nested_attributes_for :userProfile
  validates :name, presence: true, length: { maximum: 40 }

  def self.find_for_facebook_oauth(auth, signed_in_resource = nil)
    User.find_by(provider: auth.provider, uid: auth.uid)
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource = nil)
    User.find_by(provider: auth.provider, uid: auth.uid)
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        user.provider = data["provider"] if user.provider.blank?
        user.uid = data["uid"] if user.uid.blank?
        user.password = Devise.friendly_token[0, 20] if user.password.blank?
      end
      if data = session["devise.twitter_data"]
        user.email = data["email"] if user.email.blank?
        user.provider = data["provider"] if user.provider.blank?
        user.uid = data["uid"] if user.uid.blank?
        user.password = Devise.friendly_token[0, 20] if user.password.blank?
      end
    end
  end

  def update_without_current_password(params, *options)
    params.delete(:current_password)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end
    result = update(params, *options)
    clean_up_passwords
    result
  end
end
