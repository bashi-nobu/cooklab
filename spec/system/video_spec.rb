require "rails_helper"

describe "VideoFeature" do
    describe "お気に入り登録" do
        before(:each) do
            User.create!(name: 'capybara', email: 'sp2h5vb9@yahoo.co.jp', password: '00000000', password_confirmation: "00000000", confirmed_at: Time.now)
            @chef_img_file_path = Rails.root.join('spec', 'fixtures/files', 'chef_test.jpg')
            @video_img_file_path = Rails.root.join('spec', 'fixtures/files', 'test_video_thumbnail.jpg')
            chef = Chef.create!(name: "テストさん", phonetic: "てすと", introduction: "テスト経歴", biography: "テスト経歴", chef_avatar: File.open(@chef_img_file_path))
            series = Series.create!(title: "テスト", introduction: "テストですよ", thumbnail: "hogehohe.jpg", chef: chef)
            @video = Video.create!(title: "テスト動画", video_url: "https://player.vimeo.com/video/328143616", introduction: "これはテスト動画です。", thumbnail: File.open(@video_img_file_path), commentary: "これはテスト動画です。これはテスト動画です。これはテスト動画です。これはテスト動画です。これはテスト動画です。", video_order: "1", price: 0, series: series)
            visit root_path
        end

        it "お気に入り登録ができる" do
            click_on "ログイン"
            fill_in "user_email",     with: "sp2h5vb9@yahoo.co.jp"
            fill_in "user_password",     with: "00000000"
            click_button "ログイン"
            sleep 3
            visit video_path(@video.id)
            sleep 3
            like_btn = find(:xpath, "//a[contains(@href,'video_like')]")
            like_btn.click
            sleep 3
            expect(page).to have_css('.text', text: '1')
        end
    end
end