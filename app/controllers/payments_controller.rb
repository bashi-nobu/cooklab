class PaymentsController < ApplicationController
  before_action :configure_payjp_token, only: [:card_registration, :purchase_subscription, :card_change]

  def new_card
    @pay_patarn = params['pay_patarn']
  end

  def card_registration # カード登録
    payjp_token = configure_payjp_token['payjp-token']
    # 顧客情報取得
    customer = MyPayjp.get_customer_id(payjp_token, current_user)
    if customer[:error].nil?
      # DBに支払情報を登録
      Payment.registration_card_data(customer, current_user)
      User.update_pay_regi_status(current_user, 'charge')
      # ユーザーのメールアドレスをPay.jpに登録
      MyPayjp.registration_customer_email(customer, current_user.email)
      @registration_patarn = 'create'
      render 'complete'
    else
      flash.now[:alert] = 'クレジットカードの登録処理に失敗しました。お手数ですが再度カード情報をご登録ください。'
      render 'new_card'
    end
  end

  def purchase_charge # 従量課金
    amount = 100
    customer = MyPayjp.get_customer_id('', current_user)
    charge = MyPayjp.production_charge(amount,customer)
    flash.now[:alert] = '定期課金の登録処理に失敗しました。お手数ですが再度カード情報をご確認ください。' if subscription_data[:error].present?
    render 'new_card'
  end

  def purchase_subscription # 定額課金
    payjp_token = configure_payjp_token['payjp-token']
    customer = MyPayjp.get_customer_id(payjp_token, current_user)
    # プラン情報取得(プランIDはアイテムIDと購読期間(毎月month、毎年yearなど)で作成)
    plan_id = "premium"
    # 定期課金実行
    subscription_data = MyPayjp.create_subscription(customer, plan_id)
    if subscription_data[:error].nil?
      MyPayjp.registration_customer_email(customer, current_user.email)
      # DBに支払情報を登録
      Payment.set_subscription_data(subscription_data, plan_id, customer, current_user)
      User.update_pay_regi_status(current_user, 'subscription')
      @registration_patarn = 'create'
      render 'complete'
    else
      flash.now[:alert] = '定期課金の登録処理に失敗しました。お手数ですが再度カード情報をご確認ください。'
      render 'new_card'
    end
  end

  def delete_subscription
    result = MyPayjp.delete_subscription_data(current_user.payment.subscription_id)
    if result[:error].nil?
      binding.pry
      User.delete_user_subscription_data(current_user)
      @registration_patarn = 'delete'
      render 'complete'
    else
      flash.now[:alert] = 'プレミアムプランの解約手続きに失敗しました。お手数ですが再度ボタンを押下ください。'
      render 'delete'
    end
  end

  def card_change
    # 顧客情報取得
    payjp_token = configure_payjp_token['payjp-token']
    customer = MyPayjp.get_customer_id(payjp_token, current_user)
    # 現在登録されているカードの card_idを取得
    default_card_id = customer.default_card
    # カードを登録
    result = MyPayjp.cards_add(customer,payjp_token)
    if result[:error].nil?
      # 既存のカードを削除する & 新規登録したカードのidを代わりにDBに保存
      MyPayjp.cards_delete(customer, default_card_id)
      @registration_patarn = 'change'
      render 'complete'
    else
      flash.now[:alert] = 'クレジットカードの変更処理に失敗しました。お手数ですが再度カード情報をご登録ください。'
      render 'edit'
    end
  end

  def delete
  end

  def complete
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
