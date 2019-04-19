require "rails_helper"

describe "AdminUserFeature" do
    describe "料理人登録ができる" do
        before(:each) do
            @chef_img_file_path = Rails.root.join('spec', 'fixtures/files', 'chef_test.jpg')
            AdminUser.create!(email: 'adminuser@examples.com', password: '00000000', password_confirmation: "00000000")
            visit admin_root_path
            fill_in "admin_user_email",     with: "adminuser@examples.com"
            fill_in "admin_user_password",     with: "00000000"
            click_on "ログイン"
        end

        it "全ての項目を入力すれば料理人が登録される" do
            visit new_admin_chef_path
            sleep 2
            fill_in "chef_name",     with: "テスト"
            fill_in "chef_phonetic",     with: "てすと"
            fill_in "chef_introduction",     with: "これはテストです。"
            fill_in "chef_biography", with: "これはテストです。これはテストです。これはテストです。これはテストです。これはテストです。"
            attach_file('chef_chef_avatar', @chef_img_file_path)
            click_button "料理人を作成"
            sleep 2
            expect(current_path).to eq admin_chefs_path
        end
    end

    describe "動画シリーズ登録ができる" do
        before(:each) do
            @chef_img_file_path = Rails.root.join('spec', 'fixtures/files', 'chef_test.jpg')
            @video_img_file_path = Rails.root.join('spec', 'fixtures/files', 'test_video_thumbnail.jpg')
            Chef.create!(name: "テストさん", phonetic: "てすと", introduction: "テスト経歴", biography: "テスト経歴", chef_avatar: File.open(@chef_img_file_path))
            AdminUser.create!(email: 'adminuser@examples.com', password: '00000000', password_confirmation: "00000000")
            visit admin_root_path
            fill_in "admin_user_email",     with: "adminuser@examples.com"
            fill_in "admin_user_password",     with: "00000000"
            click_on "ログイン"
        end

        it "全ての項目を入力すればシリーズが登録される" do
            visit new_admin_series_path
            sleep 2
            fill_in "series_title",     with: "テストシリーズ"
            fill_in "series_introduction",     with: "これはテストです。"
            select "テストさん", from: "series_chef_id"
            click_button "動画シリーズを作成"
            sleep 2
            expect(page).to have_css('#page_title', text: 'テストシリーズ')
        end
    end

    describe "ビデオ登録ができる" do
        before(:each) do
            @chef_img_file_path = Rails.root.join('spec', 'fixtures/files', 'chef_test.jpg')
            @video_img_file_path = Rails.root.join('spec', 'fixtures/files', 'test_video_thumbnail.jpg')
            chef = Chef.create!(name: "テストさん", phonetic: "てすと", introduction: "テスト経歴", biography: "テスト経歴", chef_avatar: File.open(@chef_img_file_path))
            Series.create!(title: "テスト", introduction: "テストですよ", thumbnail: "hogehohe.jpg", chef: chef)
            AdminUser.create!(email: 'adminuser@examples.com', password: '00000000', password_confirmation: "00000000")
            visit admin_root_path
            fill_in "admin_user_email",     with: "adminuser@examples.com"
            fill_in "admin_user_password",     with: "00000000"
            click_on "ログイン"
        end

        it "全ての項目を入力すればビデオが登録される" do
            visit new_admin_video_path
            sleep 2
            fill_in "video_title",     with: "テスト動画"
            fill_in "video_video_url",     with: "https://player.vimeo.com/video/328143616"
            fill_in "video_introduction",     with: "これはテスト動画です。"
            fill_in "video_commentary", with: "これはテスト動画です。これはテスト動画です。これはテスト動画です。これはテスト動画です。これはテスト動画です。"
            select "1", from: "video_orders"
            fill_in "video_price",    with: "0"
            select "テスト", from: "series_id"
            attach_file('video_thumbnail', @video_img_file_path)
            click_button "ビデオを作成"
            sleep 2
            expect(current_path).to eq admin_videos_path
        end
    end
    describe "記事の登録ができる" do
        before(:each) do
            @chef_img_file_path = Rails.root.join('spec', 'fixtures/files', 'chef_test.jpg')
            @article_img_file_path = Rails.root.join('spec', 'fixtures/files', 'article_test.jpg')
            chef = Chef.create!(name: "テストさん", phonetic: "てすと", introduction: "テスト経歴", biography: "テスト経歴", chef_avatar: File.open(@chef_img_file_path))
            AdminUser.create!(email: 'adminuser@examples.com', password: '00000000', password_confirmation: "00000000")
            visit admin_root_path
            fill_in "admin_user_email",     with: "adminuser@examples.com"
            fill_in "admin_user_password",     with: "00000000"
            click_on "ログイン"
        end

        it "全ての項目を入力すれば記事が登録される" do
            visit new_admin_article_path
            sleep 2
            fill_in "article_title",     with: "テスト記事"
            fill_in "article-contents", with: "これはテスト記事です。これはテスト記事です。これはテスト記事です。これはテスト記事です。これはテスト記事です。"
            select "テストさん", from: "article_chef_id"
            attach_file('article_thumbnail', @article_img_file_path)
            click_button "記事を作成"
            sleep 2
            expect(current_path).to eq admin_articles_path
        end
    end
    describe "お知らせの登録ができる" do
        before(:each) do
            AdminUser.create!(email: 'adminuser@examples.com', password: '00000000', password_confirmation: "00000000")
            visit admin_root_path
            fill_in "admin_user_email",     with: "adminuser@examples.com"
            fill_in "admin_user_password",     with: "00000000"
            click_on "ログイン"
        end

        it "全ての項目を入力すれば記事が登録される" do
            visit new_admin_notice_path
            sleep 2
            fill_in "notice_title",     with: "お知らせテスト"
            fill_in "notice_message", with: "これはテストです。これはテストです。これはテストです。これはテストです。これはテストです。"
            click_button "お知らせを作成"
            sleep 2
            expect(page).to have_css('#page_title', text: 'お知らせテスト')
        end
    end
end