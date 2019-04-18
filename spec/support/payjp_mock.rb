module PayjpMock
  def self.prepare_valid_charge
    {
      "amount": 3500,
      "amount_refunded": 0,
      "captured": true,
      "captured_at": 1433127983,
      "card": {
        "address_city": nil,
        "address_line1": nil,
        "address_line2": nil,
        "address_state": nil,
        "address_zip": nil,
        "address_zip_check": "unchecked",
        "brand": "Visa",
        "country": nil,
        "created": 1433127983,
        "customer": nil,
        "cvc_check": "unchecked",
        "exp_month": 2,
        "exp_year": 2020,
        "fingerprint": "e1d8225886e3a7211127df751c86787f",
        "id": "car_d0e44730f83b0a19ba6caee04160",
        "last4": "4242",
        "name": nil,
        "object": "card"
      },
      "created": 1433127983,
      "currency": "jpy",
      "customer": nil,
      "description": nil,
      "expired_at": nil,
      "failure_code": nil,
      "failure_message": nil,
      "id": "ch_fa990a4c10672a93053a774730b0a",
      "livemode": false,
      "metadata": nil,
      "object": "charge",
      "paid": true,
      "refund_reason": nil,
      "refunded": false,
      "subscription": nil
    }
  end

  def self.create_customer
    {
      "cards": {
        "count": 0,
        "data": [],
        "has_more": false,
        "object": "list",
        "url": "/v1/customers/cus_121673955bd7aa144de5a8f6c262/cards"
      },
      "created": 1433127983,
      "default_card": nil,
      "description": "test",
      "email": nil,
      "id": "cus_121673955bd7aa144de5a8f6c262",
      "livemode": false,
      "metadata": nil,
      "object": "customer",
      "subscriptions": {
        "count": 0,
        "data": [],
        "has_more": false,
        "object": "list",
        "url": "/v1/customers/cus_121673955bd7aa144de5a8f6c262/subscriptions"
      }
    }
  end
  def self.create_charge
    {'amount' => 100, 'id'=> 'ch_fa990a4c10672a93053a774730b0a'}
  end
  def self.create_customer_error
    {
      "error": {
        "code": "invalid_param_key",
        "message": "Invalid param key to customer.",
        "param": "dummy",
        "status": 400,
        "type": "client_error"
      }
    }
  end
  def self.create_subscription
    {
      "canceled_at": nil,
      "created": 1433127983,
      "current_period_end": 1435732422,
      "current_period_start": 1433140422,
      "customer": "cus_4df4b5ed720933f4fb9e28857517",
      "id": "sub_567a1e44562932ec1a7682d746e0",
      "livemode": false,
      "metadata": nil,
      "object": "subscription",
      "paused_at": nil,
      "plan": {
        "amount": 1000,
        "billing_day": nil,
        "created": 1432965397,
        "currency": "jpy",
        "id": "pln_9589006d14aad86aafeceac06b60",
        "livemode": false,
        "metadata": {},
        "interval": "month",
        "name": "test plan",
        "object": "plan",
        "trial_days": 0
      },
      "resumed_at": nil,
      "start": 1433140422,
      "status": "active",
      "trial_end": nil,
      "trial_start": nil,
      "prorate": false
    }
  end

  def self.customer_retrieve
    {
      "cards": {
        "count": 0,
        "data": [],
        "has_more": false,
        "object": "list",
        "url": "/v1/customers/cus_121673955bd7aa144de5a8f6c262/cards"
      },
      "created": 1433127983,
      "default_card": nil,
      "description": "test",
      "email": nil,
      "id": "cus_121673955bd7aa144de5a8f6c262",
      "livemode": false,
      "metadata": nil,
      "object": "customer",
      "subscriptions": {
        "count": 0,
        "data": [],
        "has_more": false,
        "object": "list",
        "url": "/v1/customers/cus_121673955bd7aa144de5a8f6c262/subscriptions"
      }
    }
  end
  
  def self.get_subscription_data
    {
      "canceled_at": nil,
      "created": 1433127983,
      "current_period_end": 1435732422,
      "current_period_start": 1433140422,
      "customer": "cus_4df4b5ed720933f4fb9e28857517",
      "id": "sub_567a1e44562932ec1a7682d746e0",
      "livemode": false,
      "metadata": nil,
      "object": "subscription",
      "paused_at": nil,
      "plan": {
        "amount": 1000,
        "billing_day": nil,
        "created": 1432965397,
        "currency": "jpy",
        "id": "pln_9589006d14aad86aafeceac06b60",
        "livemode": false,
        "metadata": {},
        "interval": "month",
        "name": "test plan",
        "object": "plan",
        "trial_days": 0
      },
      "resumed_at": nil,
      "start": 1433140422,
      "status": "active",
      "trial_end": nil,
      "trial_start": nil,
      "prorate": false
    }
  end
end