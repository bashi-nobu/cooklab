class UsersController < ApplicationController

  def index
  end

  def my_page
    account_patarn_check
    @info_patarn = configure_info_patarn_params[:info_patarn]
    if @info_patarn == 'pay_info' && current_user.payment.present?
      customer = MyPayjp.get_customer_id('', current_user)
      brand = customer.cards.data[0].brand
      @card_brand_img_name = get_card_brand_img_name(brand)
      @last4 = customer.cards.data[0].last4
      @exp_month = customer.cards.data[0].exp_month
      @exp_year = customer.cards.data[0].exp_year
      @expires_at = current_user.payment.expires_at.to_s.dup.sub!(/\s.*/, "")
    end
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

  def get_card_brand_img_name(brand)
    @card_brand_img_name = if brand == 'Visa'
                          'Visa'
                        elsif brand == 'MasterCard'
                          'MasterCard'
                        elsif brand == 'JCB'
                          'JCB'
                        elsif brand == 'American Express'
                          'AmericanExpress'
                        elsif brand == 'Diners Club'
                          'DinersClub'
                        elsif brand == 'Discover'
                          'Discover'
                        end

  end
end
