class PaymentsController < ApplicationController
  before_action :configure_payjp_token, only: [:create, :purchase_subscription, :card_change]
  before_action :card_registration_restrict_check, only: [:new_card, :edit]

  def new_card
    # @pay_patarn = params['pay_patarn']
    @pay_patarn = 'subscription'
  end

  def create
    payjp_token = configure_payjp_token['payjp-token']
    customer = MyPayjp.get_customer_id(payjp_token, current_user)
    card_registration_restrict_status_record = CardRegistrationRestrict.find_by(user_id: current_user.id)
    @lock_check = card_registration_restrict_status_record.error_count if card_registration_restrict_status_record.present?
    if customer[:error].nil? && @lock_check != 5 && current_user.pay_regi_status_before_type_cast == 0
      Payment.registration_card_data(customer, current_user)
      User.update_pay_regi_status(current_user, 'charge')
      MyPayjp.registration_customer_email(customer, current_user.email)
      @registration_patarn = 'create'
      card_registration_restrict_reset(card_registration_restrict_status_record, 'reset') if card_registration_restrict_status_record.present?
      render 'complete'
    else
      card_registration_restrict_count_add(card_registration_restrict_status_record)
      @pay_patarn = params['pay_patarn']
      render 'new_card'
    end
  end

  def purchase_charge
    charge_check = Charge.where(user_id: current_user.id, video_id: params[:video_id])
    if charge_check.empty?
      customer = MyPayjp.get_customer_id('', current_user)
      charge_data = MyPayjp.production_charge(params[:price], customer)
      @result = charge_error_check(charge_data, params[:video_id])
    else
      @result = ['error']
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  def purchase_subscription
    payjp_token = configure_payjp_token['payjp-token']
    customer = MyPayjp.get_customer_id(payjp_token, current_user)
    card_registration_restrict_status_record = CardRegistrationRestrict.find_by(user_id: current_user.id)
    @lock_check = card_registration_restrict_status_record.error_count if card_registration_restrict_status_record.present?
    plan_id = "magazine_subsc_plan"
    subscription_data = MyPayjp.create_subscription(customer, plan_id) if customer[:error].nil?
    if customer[:error].nil? && subscription_data[:error].nil? && @lock_check != 5 && current_user.pay_regi_status_before_type_cast != 2
      MyPayjp.registration_customer_email(customer, current_user.email)
      Payment.set_subscription_data(subscription_data, plan_id, customer, current_user)
      User.update_pay_regi_status(current_user, 'subscription')
      card_registration_restrict_reset(card_registration_restrict_status_record, 'reset') if card_registration_restrict_status_record.present?
      @registration_patarn = 'create'
      render 'complete'
    else
      card_registration_restrict_count_add(card_registration_restrict_status_record)
      @pay_patarn = params['pay_patarn']
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
      flash.now[:alert] = 'メルマガ有料会員の解約手続きに失敗しました。お手数ですが再度ボタンを押下ください。'
      render 'delete'
    end
  end

  def card_change
    payjp_token = configure_payjp_token['payjp-token']
    customer = MyPayjp.get_customer_id(payjp_token, current_user)
    default_card_id = customer.default_card
    card_registration_restrict_status_record = CardRegistrationRestrict.find_by(user_id: current_user.id)
    @lock_check = card_registration_restrict_status_record.error_count if card_registration_restrict_status_record.present?
    result = MyPayjp.cards_add(customer, payjp_token)
    if result[:error].nil? && @lock_check != 5
      MyPayjp.cards_delete(customer, default_card_id)
      card_registration_restrict_reset(card_registration_restrict_status_record, 'reset') if card_registration_restrict_status_record.present?
      resume_subscription if current_user.pay_regi_status_before_type_cast == 3
      @registration_patarn = 'change'
      render 'complete'
    else
      card_registration_restrict_count_add(card_registration_restrict_status_record)
      render 'edit'
    end
  end

  private

  def charge_error_check(charge_data, video_id)
    @result = if charge_data[:error].present?
                flash[:alert] = 'ご登録されているクレジットカードでの支払いが出来ませんでした。'
                ['error']
              else
                Charge.create(user_id: current_user.id, video_id: video_id, price: charge_data['amount'], payjp_charge_id: charge_data['id'])
                flash[:notice] = '支払が完了しました。'
                ['ok']
              end
  end

  def configure_payjp_token
    if params['payjp-token'].nil?
      '-'
    else
      params.permit('payjp-token')
    end
  end

  def card_registration_restrict_check
    card_registration_restrict_status_record = CardRegistrationRestrict.find_by(user_id: current_user.id)
    card_registration_eternal_restrict_check(card_registration_restrict_status_record)
    if card_registration_restrict_status_record.nil? || (card_registration_restrict_status_record.present? && card_registration_restrict_status_record.error_count < 5)
      @card_registration_restrict_check = nil
    elsif (Time.current - card_registration_restrict_status_record.locked_at).to_i > 3_600
      card_registration_restrict_reset(card_registration_restrict_status_record, 'time_reset')
      @card_registration_restrict_check = nil
    else
      @card_registration_restrict_check = 'lock'
    end
  end

  def card_registration_eternal_restrict_check(card_registration_restrict_status_record)
    @card_registration_eternal_restrict_check = 'lock' if card_registration_restrict_status_record.present? && card_registration_restrict_status_record.total_error_count > 19
  end

  def card_registration_restrict_reset(card_registration_restrict_status_record, reset_type)
    card_registration_restrict_status_record.update(error_count: 0, locked_at: nil, total_error_count: 0) if reset_type == 'reset'
    card_registration_restrict_status_record.update(error_count: 0, locked_at: nil) if reset_type == 'time_reset'
  end

  def card_registration_restrict_count_add(card_registration_restrict_status_record)
    flash.now[:alert] = if card_registration_restrict_status_record.nil?
                          CardRegistrationRestrict.create(user_id: current_user.id, error_count: 1)
                          'クレジットカードの登録処理に失敗しました。お手数ですが再度カード情報をご登録ください。'
                        elsif (new_error_count = card_registration_restrict_status_record.error_count + 1) < 5
                          new_total_error_count = card_registration_restrict_status_record.total_error_count + 1
                          card_registration_restrict_status_record.update(error_count: new_error_count, total_error_count: new_total_error_count)
                          'クレジットカードの登録処理に失敗しました。お手数ですが再度カード情報をご登録ください。'
                        elsif new_error_count > 5
                          @card_registration_restrict_check = 'lock'
                          '無効な操作です！'
                        elsif (new_total_error_count = card_registration_restrict_status_record.total_error_count + 1) < 20
                          card_registration_restrict_status_record.update(error_count: new_error_count, locked_at: Time.now.to_i, total_error_count: new_total_error_count)
                          @card_registration_restrict_check = 'lock'
                          'クレジットカードの登録処理に5回連続失敗しました。お手数ですが１時間後に再度カード情報をご登録ください。'
                        else
                          card_registration_restrict_status_record.update(error_count: new_error_count, locked_at: Time.now.to_i, total_error_count: new_total_error_count)
                          @card_registration_restrict_check = 'lock'
                          @card_registration_eternal_restrict_check = 'lock'
                          'クレジットカードの登録処理に20回連続失敗したため、ロックがかかりました。'
                        end
  end

  def resume_subscription
    User.update_pay_regi_status(current_user, 'subscription')
    MyPayjp.resume_subscription(current_user.payment.subscription_id)
  end
end
