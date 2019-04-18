require "rails_helper"

describe "ArticleFeature" do
    describe "お気に入り登録" do
        before(:each) do
            User.create!(name: 'capybara', email: 'sp2h5vb9@yahoo.co.jp', password: '00000000', password_confirmation: "00000000", confirmed_at: Time.now)
            @chef_img_file_path = Rails.root.join('spec', 'fixtures/files', 'chef_test.jpg')
            @article_img_file_path = Rails.root.join('spec', 'fixtures/files', 'article_test.jpg')
            chef = Chef.create!(name: "テストさん", phonetic: "てすと", introduction: "テスト経歴", biography: "テスト経歴", chef_avatar: File.open(@chef_img_file_path))
            @article = Article.create!(title: "テスト記事", contents: "これはテスト記事です。これはテスト記事です。これはテスト記事です。これはテスト記事です。これはテスト記事です。", thumbnail: File.open(@article_img_file_path), chef: chef)
            visit root_path
        end

        it "お気に入り登録ができる" do
            click_on "ログイン"
            fill_in "user_email",     with: "sp2h5vb9@yahoo.co.jp"
            fill_in "user_password",     with: "00000000"
            click_button "ログイン"
            sleep 3
            visit article_path(@article.id)
            sleep 3
            like_btn = find(:xpath, "//a[contains(@href,'article_like')]")
            like_btn.click
            sleep 3
            expect(page).to have_css('.text', text: '1')
        end
    end
end