class UsersController < ApplicationController
  def index
  end

  def my_page
    account_patarn_check
    @info_patarn = configure_info_patarn_params[:info_patarn]
    @videos = current_user.videos.page(params[:page]).per(10) if @info_patarn == 'pay_video'
    @videos = Video.all.page(params[:page]).per(10) if @info_patarn == 'like_video'
    return unless @info_patarn == 'pay_info' && current_user.payment.present?
    get_card_info(current_user)
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

  def change_card_name(brand)
    if brand == 'American Express'
      'AmericanExpress'
    else
      'DinersClub'
    end
  end

  def get_card_info(user)
    card = MyPayjp.get_card_data(user)
    brand = card.brand
    brand = change_card_name(brand) if ['American Express', 'Diners Club'].include?(brand)
    @card_brand = brand
    @last4 = card.last4
    @exp_month = card.exp_month
    @exp_year = card.exp_year
    @expires_at = current_user.payment.expires_at
  end
end
