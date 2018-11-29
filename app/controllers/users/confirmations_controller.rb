# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?
    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_flashing_format?
      sign_in_count = sign_in_count_check
      sign_in(resource)
      respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource, sign_in_count) }
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity) { render :new }
    end
  end

  protected

  def after_confirmation_path_for(resource_name, resource, sign_in_count)
    new_user_registration_complete_path(sign_in_count)
  end

  def sign_in_count_check
    sign_in_count = 0 unless user_signed_in?
    sign_in_count = current_user.sign_in_count if user_signed_in?
    return sign_in_count
  end
end
