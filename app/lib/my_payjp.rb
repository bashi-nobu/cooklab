require 'payjp'

class MyPayjp
  # Payjp::api_key = ENV['PAYJP_PRIVATE_KEY'] # Production
  Payjp::api_key = Settings.payjp[:PAYJP_SECRET_KEY] # Development

  def self.get_customer_id(payjp_token, current_user)
    if current_user.payment.present?
      Payjp::Customer.retrieve(id: current_user.payment.customer_id)
    else
      Payjp::Customer.create(card:payjp_token)
    end
  rescue Payjp::InvalidRequestError => e
    e.json_body
  end

  def self.production_charge(amount,customer)
    Payjp::Charge.create(
      amount: amount,
      customer: customer.id,
      currency: 'jpy',
    )
  rescue Payjp::InvalidRequestError => e
    e.json_body
  end

  def self.create_subscription(customer, plan_id)
    plan = Payjp::Plan.retrieve(id: plan_id)
    Payjp::Subscription.create(customer: customer.id, plan: plan.id)
  rescue Payjp::InvalidRequestError => e
    subscription_data = e.json_body
  end

  def self.get_subscription_data(subscription_id)
    Payjp::Subscription.retrieve(subscription_id)
  rescue Payjp::InvalidRequestError => e
    e.json_body
  end

  def self.delete_subscription_data(subscription_id)
    subscription = Payjp::Subscription.retrieve(subscription_id)
    subscription.delete
  rescue Payjp::InvalidRequestError => e
    e.json_body
  end

  def method_name
    subscription.delete
  end

  def self.delete_customer(customer_id)
    customer = Payjp::Customer.retrieve(customer_id)
    customer.delete
  rescue Payjp::InvalidRequestError => e
    e.json_body
  end

  def self.registration_customer_email(customer, email)
    customer.email = email
    customer.save
  rescue Payjp::InvalidRequestError => e
    e.json_body
  end

  def self.cards_add(customer, payjp_token)
    customer.cards.create(card: payjp_token, default: true)
  rescue Payjp::InvalidRequestError => e
    e.json_body
  end

  def self.cards_delete(customer, card_id)
    card = customer.cards.retrieve(card_id)
    card.delete
  end

  def self.get_card_data(user)
    self.get_customer_id('-', user).cards.data[0]
  end
end
