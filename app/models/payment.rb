class Payment < ApplicationRecord
  belongs_to :user, inverse_of: :userProfile, optional: true

  def self.registration_card_data(customer, current_user)
    payment = Payment.new
    payment.customer_id = customer.id
    payment.user_id = current_user.id
    payment.save!
  end

  def self.set_subscription_data(subscription_data, plan_id, customer, current_user)
    if current_user.payment.present?
      payment = current_user.payment
      payment.subscription_id = subscription_data.id
      payment.plan_id = plan_id
      payment.expires_at = Time.zone.at(subscription_data.current_period_end)
    else
      payment = Payment.new
      payment.subscription_id = subscription_data.id
      payment.plan_id = plan_id
      payment.expires_at = Time.zone.at(subscription_data.current_period_end)
      payment.customer_id = customer.id
      payment.user_id = current_user.id
    end
    payment.save!
  end
end
