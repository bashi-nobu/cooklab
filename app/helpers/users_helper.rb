module UsersHelper
  def adjust_expires_at(expires_at)
    expires_at.to_s.dup.sub!(/\s.*/, "")
  end
end
