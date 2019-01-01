class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable
  has_one :userProfile, dependent: :destroy, inverse_of: :user
  has_one :payment, dependent: :destroy, inverse_of: :user
  has_many :charges, dependent: :destroy
  has_many :videos, through: :charges
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

  def self.update_pay_regi_status(user, pay_patarn)
    user.pay_regi_status = 1 if pay_patarn == 'charge' # 1 = カード登録済み(定額課金ではない),2 = 定額課金利用
    user.pay_regi_status = 2 if pay_patarn == 'subscription'
    user.save!
  end

  def self.delete_user_subscription_data(user)
    user.pay_regi_status = 1
    user.save!
    user.payment.subscription_id = nil
    user.payment.plan_id = nil
    user.payment.save!
  end
end
