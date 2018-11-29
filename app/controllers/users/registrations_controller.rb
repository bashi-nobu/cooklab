# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up/:account_patarn
  def new
    @account_patarn = account_patarn_params[:account_patarn]
    super
  end

  # POST /resource
  def create
    @account_patarn = account_patarn_params[:account_patarn]
    @user = User.new(configure_sign_up_params) if @account_patarn == 'mail'
    @user = User.new(configure_sign_up_params_fb) if @account_patarn == 'facebook'
    @user = User.new(configure_sign_up_params_tw) if @account_patarn == 'twitter'
    @user.skip_confirmation! unless @account_patarn == 'mail'
    if @user.save
      switch_redirect_to(@account_patarn, @user)
    else
      render 'new'
    end
  end

  # GET /resource/edit
  def edit
    @account_patarn = current_user.provider
    @account_patarn = 'mail' if current_user.provider.nil?
    @user = current_user
    super
  end

  # PUT /resource
  def update
    @account_patarn = account_patarn_params[:account_patarn]
    if @user.update_without_current_password(configure_account_update_params)
      sign_in(@user, bypass: true)
      switch_mail_aouth_redirect_to(@account_patarn, @user)
    else
      render 'edit'
    end
  end

  # DELETE /resource
  def destroy
    super
  end

  def mail_send
    @sign_in_count = configure_mail_aouth_params[:sign_in_count].to_i
  end

  def complete
    @sign_in_count = configure_mail_aouth_params[:sign_in_count].to_i
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up) do |params|
      params.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation, :pay_regi_status, userProfile_attributes: [:sex, :work_place, :job, :specialized_field, :location, :birthday]])
    end
  end

  def configure_sign_up_params_fb
    configure_sign_up_params.merge(provider: session["devise.facebook_data"]['provider'], uid: session["devise.facebook_data"]['uid'], email: session["devise.facebook_data"]['info']['email'], password: Devise.friendly_token[0, 20])
  end

  def configure_sign_up_params_tw
    configure_sign_up_params.merge(provider: session["devise.twitter_data"]['provider'], uid: session["devise.twitter_data"]['uid'], email: session["devise.twitter_data"]['info']['email'], password: Devise.friendly_token[0, 20])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.sanitize(:account_update) do |params|
      params.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation, :pay_regi_status, userProfile_attributes: [:sex, :work_place, :job, :specialized_field, :location, :birthday]])
    end
  end

  def account_patarn_params
    if action_name == 'new'
      params.permit(:account_patarn)
    else
      params.require(:user).permit(:account_patarn)
    end
  end

  def configure_mail_aouth_params
    params.permit(:sign_in_count)
  end

  def switch_redirect_to(account_patarn, resource)
    if account_patarn == 'mail'
      redirect_to new_user_registration_send_path(@user.sign_in_count)
    else
      sign_in(resource)
      redirect_to new_user_registration_complete_path(0)
    end
  end

  def switch_mail_aouth_redirect_to(account_patarn, resource)
    unless resource.unconfirmed_email.nil?
      redirect_to new_user_registration_send_path(resource.sign_in_count)
    else
      @sign_in_count = 'edit'
      render 'complete'
    end
  end
end
