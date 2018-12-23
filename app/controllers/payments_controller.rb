class PaymentsController < ApplicationController
  before_action :configure_payjp_token, only: [:create, :purchase_subscription, :card_change]

  def new_card
    @pay_patarn = params['pay_patarn']
  end

  def create
    payjp_token = configure_payjp_token['payjp-token']
    customer = MyPayjp.get_customer_id(payjp_token, current_user)
    if customer[:error].nil?
      Payment.registration_card_data(customer, current_user)
      User.update_pay_regi_status(current_user, 'charge')
      MyPayjp.registration_customer_email(customer, current_user.email)
      @registration_patarn = 'create'
      render 'complete'
    else
      flash.now[:alert] = 'クレジットカードの登録処理に失敗しました。お手数ですが再度カード情報をご登録ください。'
      render 'new_card'
    end
  end

  def purchase_charge
    amount = 100
    customer = MyPayjp.get_customer_id('', current_user)
    charge = MyPayjp.production_charge(amount, customer)
    flash.now[:alert] = '定期課金の登録処理に失敗しました。お手数ですが再度カード情報をご確認ください。' if subscription_data[:error].present?
    render 'new_card'
  end

  def purchase_subscription
    payjp_token = configure_payjp_token['payjp-token']
    customer = MyPayjp.get_customer_id(payjp_token, current_user)
    plan_id = "premium"
    subscription_data = MyPayjp.create_subscription(customer, plan_id)
    if subscription_data[:error].nil?
      MyPayjp.registration_customer_email(customer, current_user.email)
      Payment.set_subscription_data(subscription_data, plan_id, customer, current_user)
      User.update_pay_regi_status(current_user, 'subscription')
      @registration_patarn = 'create'
      render 'complete'
    else
      flash.now[:alert] = '定期課金の登録処理に失敗しました。お手数ですが再度カード情報をご確認ください。'
      render 'new_card'
    end
  end

  def destroy
    result = MyPayjp.delete_subscription_data(current_user.payment.subscription_id)
    if result[:error].nil?
      User.delete_user_subscription_data(current_user)
      @registration_patarn = 'delete'
      render 'complete'
    else
      flash.now[:alert] = 'プレミアムプランの解約手続きに失敗しました。お手数ですが再度ボタンを押下ください。'
      render 'delete'
    end
  end

  def card_change
    payjp_token = configure_payjp_token['payjp-token']
    customer = MyPayjp.get_customer_id(payjp_token, current_user)
    default_card_id = customer.default_card
    result = MyPayjp.cards_add(customer, payjp_token)
    if result[:error].nil?
      MyPayjp.cards_delete(customer, default_card_id)
      @registration_patarn = 'change'
      render 'complete'
    else
      flash.now[:alert] = 'クレジットカードの変更処理に失敗しました。お手数ですが再度カード情報をご登録ください。'
      render 'edit'
    end
  end

  private

  def configure_payjp_token
    if params['payjp-token'].nil?
      '-'
    else
      params.permit('payjp-token')
    end
  end
end