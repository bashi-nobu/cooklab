# module Sns::Tw extend self
module PayjpCheckSubscStatus extend self

  def check_status
    @users = User.where(pay_regi_status: 2)
    @user.each do |user|
      next if user.payment.subscription_id.nil?
      subscription_id = user.payment.subscription_id
      begin
        subscription = MyPayjp.get_subscription_data(subscription_id)
      rescue # 失敗時の対応
        next
      end
      expires_at = Time.zone.at(subscription.current_period_end)
      # 定額プランの有効期日が現在より過去の場合は定額課金を停止する
      unless expires_at > Time.now
        user.pay_regi_status = 100
        subscription.pause
      end
    end
  end

end
