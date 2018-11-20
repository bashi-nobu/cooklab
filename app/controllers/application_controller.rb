class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  def configure_permitted_paramaters
#devise_parameter_sanitizer = 許可するパラメータを追加（railsのバージョンによって書き方が異なるので注意）
    devise_parameter_sanitizer.permit(:sign_up, keys: [:userProfile_attributes => [:user_id, :name, :sex, :work_place, :job, :specialized_field, :location, :birthday]])
    devise_parameter_sanitizer.permit(:account_update, keys: [:userinfo_attributes => [:user_id, :name, :sex, :work_place, :job, :specialized_field, :location, :birthday]])
  end
end
