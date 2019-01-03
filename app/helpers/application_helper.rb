module ApplicationHelper
  def resource_name
   :user
  end

  def resource
     @resource ||= User.new
  end

  def devise_mapping
     @devise_mapping ||= Devise.mappings[:user]
  end

  def adjust_created_at(created_at)
    created_at.to_s.dup.sub!(/\s.*/, "").tr!("-", "/")
  end

  def adjust_brank_text(text)
    safe_join(text.split("\n"), tag(:br))
  end
end
