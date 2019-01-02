class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action  :store_location

  private

  def configure_permitted_parameters
    #devise_parameter_sanitizer = 許可するパラメータを追加（railsのバージョンによって書き方が異なるので注意）
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :pay_regi_status])
    devise_parameter_sanitizer.permit(:sign_up, keys: [userProfile_attributes: [:user_id, :sex, :work_place, :job, :specialized_field, :location, :birthday]])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :pay_regi_status])
    devise_parameter_sanitizer.permit(:account_update, keys: [userProfile_attributes: [:user_id, :sex, :work_place, :job, :specialized_field, :location, :birthday]])
  end

  def store_location
    user_id = current_user.id if user_signed_in?
    if request.fullpath != "/users/sign_in" &&
      request.fullpath != "/users/sign_up" &&
      request.fullpath != "/users" &&
      request.fullpath != "/payments/new_card/charge" &&
      request.fullpath != "/payments/#{user_id}/edit" &&
      request.fullpath != "/payments/delete" &&
      request.fullpath != "/payments/new_card/subscription" &&
      request.fullpath !~ Regexp.new("\\A/users/password.*\\z") &&
      !request.xhr? # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    if session[:previous_url] == root_path
      super
    else
      session[:previous_url] || root_path
    end
  end
end
