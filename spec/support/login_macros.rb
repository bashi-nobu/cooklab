module LoginMacros
  def login(user)
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'ログイン'
    expect(page).to have_css('div.flash', text: 'ログインしました。')
  end

  def logout
    find('.header__menu-sign-in').hover
    click_link 'ログアウト'
    expect(page).to have_css('div.flash', text: 'ログアウトしました。')
  end
end
