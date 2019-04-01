# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])
    if @user
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      @user = User.new
      redirect_to new_user_registration_customize_path('facebook')
    end
  rescue => e
    set_flash_message(:alert, :failure, kind: "Facebook") if is_navigational_format?
    failure
  end

  def twitter
    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"], current_user)
    if @user
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: "Twitter") if is_navigational_format?
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")
      @user = User.new
      redirect_to new_user_registration_customize_path('twitter')
    end
  rescue => e
    set_flash_message(:alert, :failure, kind: "Twitter") if is_navigational_format?
    failure
  end

  protected

  def failure
    redirect_to root_path
  end
end
