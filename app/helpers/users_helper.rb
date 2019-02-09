module UsersHelper
  def adjust_expires_at(expires_at)
    expires_at.to_s.dup.sub!(/\s.*/, "")
  end

  def menu_active(info_patarn, page_action)
    'selected' if info_patarn == page_action
  end

  def check_pay_regi_status()
    current_user.pay_regi_status_before_type_cast
  end
end
