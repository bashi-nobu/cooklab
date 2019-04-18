require "rails_helper"

describe "PayjpFeature" do
    describe "支払い登録ができる" do
        before(:each) do
            User.create!(name: 'capybara', email: 'sp2h5vb9@yahoo.co.jp', password: '00000000', password_confirmation: "00000000", confirmed_at: Time.now)
            allow(Payjp::Customer).to receive(:create).and_return(PayjpMock.create_customer.extend HashExtension)
            visit root_path
        end

        it "Payjpカード登録" do
            click_on "ログイン"
            fill_in "user_email",     with: "sp2h5vb9@yahoo.co.jp"
            fill_in "user_password",     with: "00000000"
            click_button "ログイン"
            visit '/users/my_page/pay_info'
            click_on "支払い方法のみ登録する"
            sleep 2
            fill_in "cc-number",     with: "4242 4242 4242 4242"
            fill_in "cc-csc",     with: "000"
            fill_in "cc-exp",     with: "0725"
            fill_in "cc-holder",     with: "TARO YAMADA"
            click_on "登録"
            sleep 2
            expect(page).to have_css('.pay-frame__complete__title', text: '完了しました')
        end
    end

    describe "支払い登録ができない" do
        before(:each) do
            User.create!(name: 'capybara', email: 'sp2h5vb9@yahoo.co.jp', password: '00000000', password_confirmation: "00000000", confirmed_at: Time.now)
            visit root_path
        end

        it "未入力項目があると登録できない" do
            click_on "ログイン"
            fill_in "user_email",     with: "sp2h5vb9@yahoo.co.jp"
            fill_in "user_password",     with: "00000000"
            click_button "ログイン"
            visit '/users/my_page/pay_info'
            click_on "支払い方法のみ登録する"
            sleep 2
            fill_in "cc-number",     with: "4242 4242 4242 4242"
            fill_in "cc-csc",     with: "000"
            fill_in "cc-exp",     with: "0725"
            # fill_in "cc-holder",     with: "TARO YAMADA"
            click_on "登録"
            sleep 2
            expect(current_path).to eq '/payments/new_card/charge'
        end
    end

    describe "支払い登録ができない" do
        before(:each) do
            @user = User.create!(name: 'capybara', email: 'sp2h5vb9@yahoo.co.jp', password: '00000000', password_confirmation: "00000000", confirmed_at: Time.now)
            allow(Payjp::Customer).to receive(:create).and_return(PayjpMock.create_customer_error.extend HashExtension)
            visit root_path
        end

        it "無効な値(有効期限)があると登録できない。かつ登録エラーカウントが１増える" do
            click_on "ログイン"
            fill_in "user_email",     with: "sp2h5vb9@yahoo.co.jp"
            fill_in "user_password",     with: "00000000"
            click_button "ログイン"
            visit '/users/my_page/pay_info'
            click_on "支払い方法のみ登録する"
            sleep 2
            fill_in "cc-number",     with: "4242 4242 4242 4242"
            fill_in "cc-csc",     with: "000"
            fill_in "cc-exp",     with: "9999"
            fill_in "cc-holder",     with: "TARO YAMADA"
            click_on "登録"
            sleep 2
            expect(page).to have_css('div.flash', text: '登録処理に失敗しました。')
            expect(@user.cardRegistrationRestrict[0].error_count).to eq(1)
        end
    end

    describe "定額課金登録ができる" do
        before(:each) do
            @user = User.create!(name: 'capybara', email: 'sp2h5vb9@yahoo.co.jp', password: '00000000', password_confirmation: "00000000", confirmed_at: Time.now)
            allow(Payjp::Customer).to receive(:create).and_return(PayjpMock.create_customer.extend HashExtension)
            allow(Payjp::Customer).to receive(:retrieve).and_return(PayjpMock.customer_retrieve.extend HashExtension)
            allow(Payjp::Subscription).to receive(:create).and_return(PayjpMock.create_subscription.extend HashExtension)
            # allow_any_instance_of(UsersController).to receive(:get_card_info).and_return(PayjpMock.card_retrieve)
            visit root_path
        end

        it "直接登録できる" do
            click_on "ログイン"
            fill_in "user_email",     with: "sp2h5vb9@yahoo.co.jp"
            fill_in "user_password",     with: "00000000"
            click_button "ログイン"
            visit '/users/my_page/pay_info'
            click_on "月額1,280円のプレミアムプランを利用する"
            sleep 2
            fill_in "cc-number",     with: "4242 4242 4242 4242"
            fill_in "cc-csc",     with: "000"
            fill_in "cc-exp",     with: "9999"
            fill_in "cc-holder",     with: "TARO YAMADA"
            click_on "登録"
            sleep 2
            expect(page).to have_css('.pay-frame__complete__title', text: 'プレミアムプランの登録手続きが 完了しました')
        end

        it "カード登録後に定額課金登録できる" do
            click_on "ログイン"
            fill_in "user_email",     with: "sp2h5vb9@yahoo.co.jp"
            fill_in "user_password",     with: "00000000"
            click_button "ログイン"
            visit '/users/my_page/pay_info'
            click_on "支払い方法のみ登録する"
            sleep 2
            fill_in "cc-number",     with: "4242 4242 4242 4242"
            fill_in "cc-csc",     with: "000"
            fill_in "cc-exp",     with: "9999"
            fill_in "cc-holder",     with: "TARO YAMADA"
            click_on "登録"
            sleep 2
            # click_on "戻る"
            # sleep 2
            visit "/payments/new_card/subscription"
            # click_on "月額1,280円のプレミアムプランを利用する"
            sleep 2
            click_on "プレミアムプラン(¥1,280/月,税別)に登録"
            sleep 2
            expect(page).to have_css('.pay-frame__complete__title', text: 'プレミアムプランの登録手続きが 完了しました')
        end
    end

    describe "有料ビデオの購入ができる" do
        before(:each) do
            @chef_img_file_path = Rails.root.join('spec', 'fixtures/files', 'chef_test.jpg')
            @video_img_file_path = Rails.root.join('spec', 'fixtures/files', 'test_video_thumbnail.jpg')
            chef = Chef.create!(name: "テストさん", phonetic: "てすと", introduction: "テスト経歴", biography: "テスト経歴", chef_avatar: File.open(@chef_img_file_path))
            series = Series.create!(title: "テスト", introduction: "テストですよ", thumbnail: "hogehohe.jpg", chef: chef)
            @video = Video.create!(title: "テスト動画", video_url: "https://player.vimeo.com/video/328143616", introduction: "これはテスト動画です。", thumbnail: File.open(@video_img_file_path), commentary: "これはテスト動画です。これはテスト動画です。これはテスト動画です。これはテスト動画です。これはテスト動画です。", video_order: "1", price: "100", series: series)
            @user = User.create!(name: 'capybara', email: 'sp2h5vb9@yahoo.co.jp', password: '00000000', password_confirmation: "00000000", confirmed_at: Time.now)
            allow(Payjp::Customer).to receive(:create).and_return(PayjpMock.create_customer.extend HashExtension)
            allow(Payjp::Customer).to receive(:retrieve).and_return(PayjpMock.customer_retrieve.extend HashExtension)
            allow(Payjp::Charge).to receive(:create).and_return(PayjpMock.create_charge)
            visit root_path
        end

        it "有料ビデオの購入ができる" do
            click_on "ログイン"
            fill_in "user_email",     with: "sp2h5vb9@yahoo.co.jp"
            fill_in "user_password",     with: "00000000"
            click_button "ログイン"
            visit '/users/my_page/pay_info'
            click_on "支払い方法のみ登録する"
            sleep 2
            fill_in "cc-number",     with: "4242 4242 4242 4242"
            fill_in "cc-csc",     with: "000"
            fill_in "cc-exp",     with: "0725"
            fill_in "cc-holder",     with: "TARO YAMADA"
            click_on "登録"
            sleep 1
            visit video_path(@video.id)
            sleep 1
            click_on "¥100を支払う"
            sleep 1
            click_on "video-pay-btn"
            sleep 4
            expect(page).to have_css('div.flash', text: '支払が完了しました。')
        end
    end

    private

    module HashExtension
      def method_missing(method, *params)
        if method.to_s[-1,1] == "="
          # シンボルキーに優先的に書き込む
          key = method.to_s[0..-2].gsub(':', '')
          key = self.has_key?(key.to_sym) ? key.to_sym :
            ( self.has_key?(key.to_s) ? key.to_s : key.to_sym )
          self[key] = params.first
        else
          # シンボルキーとストリングキー両方存在する場合、
          # シンボルキーを優先的に返す
          key = self.has_key?(method.to_sym) ? method.to_sym : method.to_s
          self[key]
        end
      end
    end
end