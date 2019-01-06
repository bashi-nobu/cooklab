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

  def show_order_select_list
    if controller.action_name == 'index'
      [["新着順", "new"], ["人気順", "like"]]
    else
      [["人気順", "like"], ["新着順", "new"]]
    end
  end
end
