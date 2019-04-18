module ControllerMacros
  def login_admin(admin)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in admin
  end

  def login_user(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user.confirm
    sign_in user
  end
end


# @request.env[“devise.mapping”] = Devise.mappings[:user]

# これは、routes.rbの中に記載されている、deviseforのリソースをマッピングするための処理になります。具体的に言うと、後程使用する「signin」などが使用できるようになります。
