module UsersHelper
  def adjust_expires_at(expires_at)
    expires_at.to_s.dup.sub!(/\s.*/, "")
  end

  def menu_active(info_patarn, page_action)
    'selected' if info_patarn == page_action
  end
end
