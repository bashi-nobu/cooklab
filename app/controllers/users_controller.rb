class UsersController < ApplicationController
  def index
  end

  def my_page
    account_patarn_check
    @info_patarn = configure_info_patarn_params[:info_patarn]
  end

  private

  def account_patarn_check
    @account_patarn = current_user.provider
    @account_patarn = 'mail' if current_user.provider.nil?
    @account_aouth = 'Facebook' if @account_patarn == 'facebook'
    @account_aouth = 'twitter' if @account_patarn == 'twitter'
    @account_aouth = 'メールアドレス' if @account_patarn == 'mail'
  end

  def configure_info_patarn_params
    params.permit(:info_patarn)
  end
end
