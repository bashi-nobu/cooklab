require "rails_helper"

RSpec.describe "Responsive", type: :system do
    describe "ナビゲーションバー" do
        before do
            @user = FactoryGirl.create(:testuser)
        end

        it "ナビゲーションバーの各リンクから指定のページにアクセスできる(未ログイン&width:640以下)" do
            visit root_path
            Capybara.current_session.driver.browser.manage.window.resize_to(500, 720)
            sleep(1)
            page.find(".navi-login-btn").click
            sleep(1)
            expect(current_path).to eq new_user_session_path

            sleep(1)
            find(".navigation-bar-sign-up-link").click # "新規登録"
            sleep(1)
            expect(current_path).to eq users_path

            sleep(1)
            click_on "ホーム"
            sleep(1)
            expect(current_path).to eq root_path

            sleep(1)
            find(".search-btn").click # "さがす"
            sleep(1)
            expect(page.find('body')).to have_selector('.search-frame', count: 1)        
        end

        it "ナビゲーションバーの各リンクから指定のページにアクセスできる(ログイン済み&width:640以下)" do
            login(@user)
            visit root_path
            Capybara.current_session.driver.browser.manage.window.resize_to(500, 720)

            sleep(1)
            find(".search-btn").click # "さがす"
            sleep(1)
            expect(page.find('body')).to have_selector('.search-frame', count: 1)

            sleep(1)
            click_on "マイページ"
            sleep(1)
            expect(current_path).to eq user_my_page_path('notice')
            sleep(1)

            sleep(1)
            click_on "ホーム"
            sleep(1)
            expect(current_path).to eq root_path

            sleep(1)
            click_on "ログアウト"
            sleep(1)
            expect(page).to have_css('div.flash', text: 'ログアウトしました。')            
        end
    end
end