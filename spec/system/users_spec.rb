require "rails_helper"

describe "UserFeature" do

    describe "メール認証でサインアップする" do
        before do
            visit root_path
            # 新規登録ボタンをクリック
            page.first(".new-btn").click
        end

        it "ユーザー情報の入力後に登録ボタンを押すと認証メールが送信される" do
            click_on "メールアドレスで登録"
            sleep 2
            fill_in "user_email",     with: "user@example.com"
            fill_in "user_password",     with: "foobar"
            fill_in "user_password_confirmation", with: "foobar"
            fill_in "user_name",         with: "Example User"
            sleep 2
            expect { click_button "新規登録" }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        before do
            visit root_path
            # 新規登録ボタンをクリック
            page.first(".new-btn").click
        end
        it "ユーザー情報の入力後に登録ボタンを押すとメール認証の案内ページに遷移する" do
            click_on "メールアドレスで登録"
            sleep 2
            fill_in "user_email",     with: "user@example.com"
            fill_in "user_password",     with: "foobar"
            fill_in "user_password_confirmation", with: "foobar"
            fill_in "user_name",         with: "Example User"
            click_button "新規登録"
            sleep 2
            expect(current_path).to eq "/users/send/0"
        end
    end

    describe "メール認証でログインする" do
        before do  # confirmed_atが未定義だと本登録が完了していない状態になりログインできない
            User.create!(name: 'capybara', email: 'sp2h5vb9@yahoo.co.jp', password: '00000000', password_confirmation: "00000000", confirmed_at: Time.now)
            visit root_path
        end
        it "メール認証が完了している場合はログインできる" do
            click_on "ログイン"
            fill_in "user_email",     with: "sp2h5vb9@yahoo.co.jp"
            fill_in "user_password",     with: "00000000"
            click_button "ログイン"
            expect(page).to have_css('div.flash', text: 'ログインしました。')
        end
    end

    describe "メール認証でログイン不可" do
        before do  # confirmed_atが未定義だと本登録が完了していない状態になりログインできない
            User.create!(name: 'capybara', email: 'sp2h5vb9@yahoo.co.jp', password: '00000000', password_confirmation: "00000000")
            visit root_path
        end
        it "メール認証が完了していない場合はログインできない" do
            click_on "ログイン"
            fill_in "user_email",     with: "sp2h5vb9@yahoo.co.jp"
            fill_in "user_password",     with: "00000000"
            click_button "ログイン"
            expect(page).to have_css('div.flash', text: '本登録を行ってください。')
        end
    end

    describe "facebook認証でサインアップする" do

        before do
            OmniAuth.config.mock_auth[:facebook] = nil
            Rails.application.env_config['omniauth.auth'] = facebook_mock
            visit root_path
            # 新規登録ボタンをクリック
            page.first(".new-btn").click
        end

        it "Facebook認証が完了したらユーザー情報の登録画面に切り替わり、そこでユーザー情報を入力し新規登録ボタンを押すと登録完了画面に遷移する" do
            #"Facebookで登録" ボタンをクリック
            click_on "Facebookで登録"
            sleep 2
            fill_in "user_name",         with: "Example User"
            click_button "新規登録"
            sleep 2
            expect(current_path).to eq "/users/complete/0"
        end
    end
    describe "facebook認証でログインする" do

        before do
            OmniAuth.config.mock_auth[:facebook] = nil
            Rails.application.env_config['omniauth.auth'] = facebook_mock
            visit root_path
            # 新規登録ボタンをクリック
            page.first(".new-btn").click
        end
        it "Facebook認証でログインできる" do
            #"Facebookで登録" ボタンをクリック
            click_on "Facebookで登録"
            sleep 2
            fill_in "user_name",         with: "Example User"
            click_button "新規登録"
            sleep 2
            click_on "ログアウト"
            sleep 2
            click_on "ログイン"
            click_on "Facebook"
            expect(page).to have_css('div.flash', text: 'Facebook から承認されました。')
            expect(current_path).to eq root_path
        end
    end
    describe "twitter認証でサインアップする" do

        before do
            OmniAuth.config.mock_auth[:twitter] = nil
            Rails.application.env_config['omniauth.auth'] = twitter_mock
            visit root_path
            # 新規登録ボタンをクリック
            page.first(".new-btn").click
        end

        it "twitter認証が完了したらユーザー情報の登録画面に切り替わり、そこでユーザー情報を入力し新規登録ボタンを押すと登録完了画面に遷移する" do
            #"Facebookで登録" ボタンをクリック
            click_on "Twitterで登録"
            # expect(current_path).to eq "/users/sign_up/twitter"
            sleep 2
            fill_in "user_name",         with: "Example User"
            click_button "新規登録"
            sleep 2
            expect(current_path).to eq "/users/complete/0"
        end
    end
    describe "twitter認証でログインする" do

        before do
            OmniAuth.config.mock_auth[:twitter] = nil
            Rails.application.env_config['omniauth.auth'] = twitter_mock
            visit root_path
            # 新規登録ボタンをクリック
            page.first(".new-btn").click
        end
        it "twitter認証でログインできる" do
            #"Facebookで登録" ボタンをクリック
            click_on "Twitterで登録"
            # expect(current_path).to eq "/users/sign_up/twitter"
            sleep 2
            fill_in "user_name",         with: "Example User"
            click_button "新規登録"
            sleep 2
            click_on "ログアウト"
            sleep 2
            click_on "ログイン"
            click_on "Twitter"
            expect(page).to have_css('div.flash', text: 'Twitter から承認されました。')
            expect(current_path).to eq root_path
        end
    end
end