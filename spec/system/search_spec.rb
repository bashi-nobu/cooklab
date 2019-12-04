require "rails_helper"

describe "SearchFeature" do

    describe "検索メニュー機能(video)" do
        before do
            @user = FactoryGirl.create(:testuser)
            # User.create!(name: 'capybara', email: 'sp2h5vb9@yahoo.co.jp', password: '00000000', password_confirmation: "00000000", confirmed_at: Time.now)
            @chef_img_file_path = Rails.root.join('spec', 'fixtures/files', 'chef_test.jpg')
            @video_img_file_path = Rails.root.join('spec', 'fixtures/files', 'test_video_thumbnail.jpg')
            @chef = Chef.create!(name: "テストさん", phonetic: "てすと", introduction: "テスト経歴", biography: "テスト経歴", chef_avatar: File.open(@chef_img_file_path))
            @series1 = Series.create!(title: "テストシリーズ１", introduction: "テストですよ", thumbnail: "hogehohe.jpg", chef: @chef)
            @series2 = Series.create!(title: "テストシリーズ２", introduction: "テストですよ", thumbnail: "hogehohe.jpg", chef: @chef)
            @video1 = Video.create!(title: "テスト動画1", video_url: "https://player.vimeo.com/video/328143616", introduction: "これはテスト動画１です。", thumbnail: File.open(@video_img_file_path), commentary: "これはテスト動画です。これはテスト動画です。これはテスト動画です。これはテスト動画です。これはテスト動画です。", tag_list: 'フランス料理', video_order: "1", price: 0, series: @series1)
            @video2 = Video.create!(title: "テスト動画2", video_url: "https://player.vimeo.com/video/328143616", introduction: "これはテスト動画２です。", thumbnail: File.open(@video_img_file_path), commentary: "これはテスト動画です。これはテスト動画です。これはテスト動画です。これはテスト動画です。これはテスト動画です。", tag_list: '和食', video_order: "2", price: 0, series: @series2)
            visit root_path
        end

        it "ヘッダーの検索アイコンをクリックすると検索メニューが表示される(画面サイズ1120以上)" do
            Capybara.current_session.driver.browser.manage.window.resize_to(1130, 720)
            #検索メニューが表示されていないことをチェック
            expect(page.find('body')).to have_selector('.search-frame', count: 0)
            #検索メニューを表示させる
            page.find('.header__search-icon').click
            sleep(1)
            expect(page.find('body')).to have_selector('.search-frame', count: 1)
        end

        it "検索メニューのジャンル欄に登録されているジャンルが表示される(画面サイズ1120以上)" do
            Capybara.current_session.driver.browser.manage.window.resize_to(1130, 720)
            page.find('.header__search-icon').click
            sleep(1)
            expect(page.find('.search-frame').all('.search-frame__box')[1].all('.genre-tag')[0].text).to eq @video1.tag_list[0]
            expect(page.find('.search-frame').all('.search-frame__box')[1].all('.genre-tag')[1].text).to eq @video2.tag_list[0]
        end

        it "検索メニューのシリーズ欄に登録されているvideoのシリーズが表示される(画面サイズ1120以上)" do
            Capybara.current_session.driver.browser.manage.window.resize_to(1130, 720)
            page.find('.header__search-icon').click
            sleep(1)
            expect(page.find('.search-frame').all('.search-frame__box')[2].all('.series-tag')[0].text).to eq @video1.series.title
            expect(page.find('.search-frame').all('.search-frame__box')[2].all('.series-tag')[1].text).to eq @video2.series.title
        end

        it " video名で検索" do
            Capybara.current_session.driver.browser.manage.window.resize_to(1130, 720)
            page.find('.header__search-icon').click
            sleep(1)
            page.all('.s-window')[0].set @video1.title
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('.v-s-list')).to have_selector('.v-s-list__box', count: 1)
            expect(page.all('.v-s-list__box')[0].find('.v-s-list__box__detail').find('.v-s-list__box__detail__title')).to have_css('p', text: "#{@video1.title} 〜#{@video1.series.title}シリーズ〜")

            visit root_path
            sleep(1)
            page.find('.header__search-icon').click
            sleep(1)
            page.all('.s-window')[0].set @video2.title
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('.v-s-list')).to have_selector('.v-s-list__box', count: 1)
            expect(page.all('.v-s-list__box')[0].find('.v-s-list__box__detail').find('.v-s-list__box__detail__title')).to have_css('p', text: "#{@video2.title} 〜#{@video2.series.title}シリーズ〜")
        end

        it "videoの紹介文で検索" do
            Capybara.current_session.driver.browser.manage.window.resize_to(1130, 720)
            page.find('.header__search-icon').click
            sleep(1)
            page.all('.s-window')[0].set @video1.introduction[0..15]
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('.v-s-list')).to have_selector('.v-s-list__box', count: 1)
            expect(page.all('.v-s-list__box')[0].find('.v-s-list__box__detail').find('.v-s-list__box__detail__title')).to have_css('p', text: "#{@video1.title} 〜#{@video1.series.title}シリーズ〜")

            visit root_path
            sleep(1)
            page.find('.header__search-icon').click
            sleep(1)
            page.all('.s-window')[0].set @video2.introduction[0..15]
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('.v-s-list')).to have_selector('.v-s-list__box', count: 1)
            expect(page.all('.v-s-list__box')[0].find('.v-s-list__box__detail').find('.v-s-list__box__detail__title')).to have_css('p', text: "#{@video2.title} 〜#{@video2.series.title}シリーズ〜")
        end

        it "ジャンル検索" do
            Capybara.current_session.driver.browser.manage.window.resize_to(1130, 720)
            page.find('.header__search-icon').click
            sleep(1)
            page.find('.search-frame').all('.search-frame__box')[1].all('.genre-tag')[0].click
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('.v-s-list')).to have_selector('.v-s-list__box', count: 1)
            expect(page.all('.v-s-list__box')[0].find('.v-s-list__box__detail').find('.v-s-list__box__detail__title')).to have_css('p', text: "#{@video1.title} 〜#{@video1.series.title}シリーズ〜")

            visit root_path
            sleep(1)
            page.find('.header__search-icon').click
            sleep(1)
            page.find('.search-frame').all('.search-frame__box')[1].all('.genre-tag')[1].click
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('.v-s-list')).to have_selector('.v-s-list__box', count: 1)
            expect(page.all('.v-s-list__box')[0].find('.v-s-list__box__detail').find('.v-s-list__box__detail__title')).to have_css('p', text: "#{@video2.title} 〜#{@video2.series.title}シリーズ〜")
        end

        it "シリーズ検索" do
            Capybara.current_session.driver.browser.manage.window.resize_to(1130, 720)
            page.find('.header__search-icon').click
            sleep(1)
            page.find('.search-frame').all('.search-frame__box')[2].all('.series-tag')[0].click
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('.v-s-list')).to have_selector('.v-s-list__box', count: 1)
            expect(page.all('.v-s-list__box')[0].find('.v-s-list__box__detail').find('.v-s-list__box__detail__title')).to have_css('p', text: "#{@video1.title} 〜#{@video1.series.title}シリーズ〜")

            visit root_path
            sleep(1)
            page.find('.header__search-icon').click
            sleep(1)
            page.find('.search-frame').all('.search-frame__box')[2].all('.series-tag')[1].click
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('.v-s-list')).to have_selector('.v-s-list__box', count: 1)
            expect(page.all('.v-s-list__box')[0].find('.v-s-list__box__detail').find('.v-s-list__box__detail__title')).to have_css('p', text: "#{@video2.title} 〜#{@video2.series.title}シリーズ〜")
        end

        it "ジャンル&トピック検索" do
            Capybara.current_session.driver.browser.manage.window.resize_to(1130, 720)
            page.find('.header__search-icon').click
            sleep(1)
            page.find('.search-frame').all('.search-frame__box')[1].all('.genre-tag')[0].click
            page.find('.search-frame').all('.search-frame__box')[2].all('.series-tag')[0].click
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('.v-s-list')).to have_selector('.v-s-list__box', count: 1)
            expect(page.all('.v-s-list__box')[0].find('.v-s-list__box__detail').find('.v-s-list__box__detail__title')).to have_css('p', text: "#{@video1.title} 〜#{@video1.series.title}シリーズ〜")

            visit root_path
            sleep(1)
            page.find('.header__search-icon').click
            sleep(1)
            page.find('.search-frame').all('.search-frame__box')[1].all('.genre-tag')[1].click
            page.find('.search-frame').all('.search-frame__box')[2].all('.series-tag')[1].click
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('.v-s-list')).to have_selector('.v-s-list__box', count: 1)
            expect(page.all('.v-s-list__box')[0].find('.v-s-list__box__detail').find('.v-s-list__box__detail__title')).to have_css('p', text: "#{@video2.title} 〜#{@video2.series.title}シリーズ〜")
        
            visit root_path
            sleep(1)
            page.find('.header__search-icon').click
            sleep(1)
            page.find('.search-frame').all('.search-frame__box')[1].all('.genre-tag')[0].click
            page.find('.search-frame').all('.search-frame__box')[2].all('.series-tag')[1].click
            sleep(1)
            page.all('.search-frame__submit__btn')[1].click
            sleep(2)
            expect(page.find('body')).to have_selector('.v-s-list__box', count: 0)

            visit root_path
            sleep(1)
            page.find('.header__search-icon').click
            sleep(1)
            page.find('.search-frame').all('.search-frame__box')[1].all('.genre-tag')[1].click
            page.find('.search-frame').all('.search-frame__box')[2].all('.series-tag')[0].click
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('body')).to have_selector('.v-s-list__box', count: 0)
        end

        it "キーワード&ジャンル&トピック検索" do
            Capybara.current_session.driver.browser.manage.window.resize_to(1130, 720)
                        
            visit root_path
            page.find('.header__search-icon').click
            sleep(1)
            page.all('.s-window')[0].set @video1.title
            page.find('.search-frame').all('.search-frame__box')[1].all('.genre-tag')[0].click
            page.find('.search-frame').all('.search-frame__box')[2].all('.series-tag')[0].click
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('.v-s-list')).to have_selector('.v-s-list__box', count: 1)
            expect(page.all('.v-s-list__box')[0].find('.v-s-list__box__detail').find('.v-s-list__box__detail__title')).to have_css('p', text: "#{@video1.title} 〜#{@video1.series.title}シリーズ〜")
  
            visit root_path
            page.find('.header__search-icon').click
            sleep(1)
            page.all('.s-window')[1].set @video2.title
            page.find('.search-frame').all('.search-frame__box')[1].all('.genre-tag')[1].click
            page.find('.search-frame').all('.search-frame__box')[2].all('.series-tag')[1].click
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('.v-s-list')).to have_selector('.v-s-list__box', count: 1)
            expect(page.all('.v-s-list__box')[0].find('.v-s-list__box__detail').find('.v-s-list__box__detail__title')).to have_css('p', text: "#{@video2.title} 〜#{@video2.series.title}シリーズ〜")

            visit root_path
            page.find('.header__search-icon').click
            sleep(1)
            page.all('.s-window')[0].set @video2.title
            page.find('.search-frame').all('.search-frame__box')[1].all('.genre-tag')[0].click
            page.find('.search-frame').all('.search-frame__box')[2].all('.series-tag')[0].click
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('body')).to have_selector('.v-s-list__box', count: 0)
  
            visit root_path
            page.find('.header__search-icon').click
            sleep(1)
            page.all('.s-window')[0].set @video1.title
            page.find('.search-frame').all('.search-frame__box')[1].all('.genre-tag')[1].click
            page.find('.search-frame').all('.search-frame__box')[2].all('.series-tag')[1].click
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('body')).to have_selector('.v-s-list__box', count: 0)

            # 全ジャンル選択
            visit root_path
            page.find('.header__search-icon').click
            sleep(1)
            page.find('.search-frame').all('.search-frame__box')[1].all('.genre-tag')[0].click
            page.find('.search-frame').all('.search-frame__box')[1].all('.genre-tag')[1].click
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('body')).to have_selector('.v-s-list__box', count: 2)

            # 全シリーズタグ選択
            visit root_path
            page.find('.header__search-icon').click
            sleep(1)

            page.find('.search-frame').all('.search-frame__box')[2].all('.series-tag')[0].click
            page.find('.search-frame').all('.search-frame__box')[2].all('.series-tag')[1].click
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('body')).to have_selector('.v-s-list__box', count: 2)

            # 全ジャンル＆全トピックタグ選択
            visit root_path
            page.find('.header__search-icon').click
            sleep(1)

            page.find('.search-frame').all('.search-frame__box')[1].all('.genre-tag')[0].click
            page.find('.search-frame').all('.search-frame__box')[1].all('.genre-tag')[1].click
            page.find('.search-frame').all('.search-frame__box')[2].all('.series-tag')[0].click
            page.find('.search-frame').all('.search-frame__box')[2].all('.series-tag')[1].click
            sleep(1)
            page.all('.search-frame__submit__btn')[0].click
            sleep(2)
            expect(page.find('body')).to have_selector('.v-s-list__box', count: 2)
        end
    end

    describe "検索メニュー機能(TOPページの検索窓)" do
        before do
            @user = FactoryGirl.create(:testuser)
            # User.create!(name: 'capybara', email: 'sp2h5vb9@yahoo.co.jp', password: '00000000', password_confirmation: "00000000", confirmed_at: Time.now)
            @chef_img_file_path = Rails.root.join('spec', 'fixtures/files', 'chef_test.jpg')
            @video_img_file_path = Rails.root.join('spec', 'fixtures/files', 'test_video_thumbnail.jpg')
            @chef = Chef.create!(name: "テストさん", phonetic: "てすと", introduction: "テスト経歴", biography: "テスト経歴", chef_avatar: File.open(@chef_img_file_path))
            @series1 = Series.create!(title: "テストシリーズ１", introduction: "テストですよ", thumbnail: "hogehohe.jpg", chef: @chef)
            @series2 = Series.create!(title: "テストシリーズ２", introduction: "テストですよ", thumbnail: "hogehohe.jpg", chef: @chef)
            @video1 = Video.create!(title: "テスト動画1", video_url: "https://player.vimeo.com/video/328143616", introduction: "これはテスト動画１です。", thumbnail: File.open(@video_img_file_path), commentary: "これはテスト動画です。これはテスト動画です。これはテスト動画です。これはテスト動画です。これはテスト動画です。", tag_list: 'フランス料理', video_order: "1", price: 0, series: @series1)
            @video2 = Video.create!(title: "テスト動画2", video_url: "https://player.vimeo.com/video/328143616", introduction: "これはテスト動画２です。", thumbnail: File.open(@video_img_file_path), commentary: "これはテスト動画です。これはテスト動画です。これはテスト動画です。これはテスト動画です。これはテスト動画です。", tag_list: '和食', video_order: "2", price: 0, series: @series2)
            visit root_path
        end

        it " video名で検索" do
            Capybara.current_session.driver.browser.manage.window.resize_to(1130, 720)
            sleep(1)
            page.all('.s-window-top')[0].set @video1.title
            sleep(1)
            page.all('.s-submit-top')[0].click
            sleep(2)
            expect(page.find('.v-s-list')).to have_selector('.v-s-list__box', count: 1)
            expect(page.all('.v-s-list__box')[0].find('.v-s-list__box__detail').find('.v-s-list__box__detail__title')).to have_css('p', text: "#{@video1.title} 〜#{@video1.series.title}シリーズ〜")

            visit root_path
            sleep(1)
            page.all('.s-window-top')[0].set @video2.title
            sleep(1)
            page.all('.s-submit-top')[0].click
            sleep(2)
            expect(page.find('.v-s-list')).to have_selector('.v-s-list__box', count: 1)
            expect(page.all('.v-s-list__box')[0].find('.v-s-list__box__detail').find('.v-s-list__box__detail__title')).to have_css('p', text: "#{@video2.title} 〜#{@video2.series.title}シリーズ〜")
        end

        it "videoの紹介文で検索" do
            Capybara.current_session.driver.browser.manage.window.resize_to(1130, 720)
            page.all('.s-window-top')[0].set @video1.introduction[0..15]
            sleep(1)
            page.all('.s-submit-top')[0].click
            sleep(2)
            expect(page.find('.v-s-list')).to have_selector('.v-s-list__box', count: 1)
            expect(page.all('.v-s-list__box')[0].find('.v-s-list__box__detail').find('.v-s-list__box__detail__title')).to have_css('p', text: "#{@video1.title} 〜#{@video1.series.title}シリーズ〜")

            visit root_path
            sleep(1)
            page.all('.s-window-top')[0].set @video2.introduction[0..15]
            sleep(1)
            page.all('.s-submit-top')[0].click
            sleep(2)
            expect(page.find('.v-s-list')).to have_selector('.v-s-list__box', count: 1)
            expect(page.all('.v-s-list__box')[0].find('.v-s-list__box__detail').find('.v-s-list__box__detail__title')).to have_css('p', text: "#{@video2.title} 〜#{@video2.series.title}シリーズ〜")
        end
    end

    describe "検索メニュー機能(article)" do
        before do
            @user = FactoryGirl.create(:testuser)
            @chef_img_file_path = Rails.root.join('spec', 'fixtures/files', 'chef_test.jpg')
            @article_img_file_path = Rails.root.join('spec', 'fixtures/files', 'article_test.jpg')
            @chef = Chef.create!(name: "テストさん", phonetic: "てすと", introduction: "テスト経歴", biography: "テスト経歴", chef_avatar: File.open(@chef_img_file_path))
            @article1 = Article.create!(title: "テスト記事1", description: "これはテスト記事1の説明文です。これはテスト記事1です。これはテスト記事です。これはテスト記事です。これはテスト記事です。", contents: "これはテスト記事1の本文です。これはテスト記事1です。これはテスト記事です。これはテスト記事です。これはテスト記事です。", thumbnail: File.open(@article_img_file_path), chef: @chef, tag_list: 'フランス料理')
            @article2 = Article.create!(title: "テスト記事2", description: "これはテスト記事2の説明文です。これはテスト記事2です。これはテスト記事です。これはテスト記事です。これはテスト記事です。", contents: "これはテスト記事2の本文です。これはテスト記事2です。これはテスト記事です。これはテスト記事です。これはテスト記事です。", thumbnail: File.open(@article_img_file_path), chef: @chef, tag_list: 'イタリア料理')
            visit root_path
        end

        it "記事名で検索" do
            Capybara.current_session.driver.browser.manage.window.resize_to(1130, 720)
            page.find('.header__search-icon').click
            sleep(1)
            page.all('.s-window')[1].set @article1.title
            sleep(1)
            page.all('.search-frame__submit__btn')[1].click
            sleep(2)
            expect(page.find('.article__search-result')).to have_selector('.a-search-result__box', count: 1)
            expect(page.all('.a-search-result__box')[0].find('.a-search-result__box__detail').find('.a-search-result__box__detail__title')).to have_content(@article1.title)

            visit root_path
            sleep(1)
            page.find('.header__search-icon').click
            sleep(1)
            page.all('.s-window')[1].set @article2.title
            sleep(1)
            page.all('.search-frame__submit__btn')[1].click
            sleep(2)
            expect(page.find('.article__search-result')).to have_selector('.a-search-result__box', count: 1)
            expect(page.all('.a-search-result__box')[0].find('.a-search-result__box__detail').find('.a-search-result__box__detail__title')).to have_content(@article2.title)
        end

        it "記事の説明文で検索" do
            Capybara.current_session.driver.browser.manage.window.resize_to(1130, 720)
            page.find('.header__search-icon').click
            sleep(1)
            page.all('.s-window')[1].set @article1.description[0..15]
            sleep(1)
            page.all('.search-frame__submit__btn')[1].click
            sleep(2)
            expect(page.find('.article__search-result')).to have_selector('.a-search-result__box', count: 1)
            expect(page.all('.a-search-result__box')[0].find('.a-search-result__box__detail').find('.a-search-result__box__detail__title')).to have_content(@article1.title)

            visit root_path
            sleep(1)
            page.find('.header__search-icon').click
            sleep(1)
            page.all('.s-window')[1].set @article2.description[0..15]
            sleep(1)
            page.all('.search-frame__submit__btn')[1].click
            sleep(2)
            expect(page.find('.article__search-result')).to have_selector('.a-search-result__box', count: 1)
            expect(page.all('.a-search-result__box')[0].find('.a-search-result__box__detail').find('.a-search-result__box__detail__title')).to have_content(@article2.title)
        end

        it "記事のジャンルで検索" do
            Capybara.current_session.driver.browser.manage.window.resize_to(1130, 720)
            page.find('.header__search-icon').click
            sleep(1)
            page.find('.search-frame').all('.search-frame__box')[5].all('.genre-tag')[0].click
            sleep(1)
            page.all('.search-frame__submit__btn')[1].click
            sleep(2)
            expect(page.find('.article__search-result')).to have_selector('.a-search-result__box', count: 1)
            expect(page.all('.a-search-result__box')[0].find('.a-search-result__box__detail').find('.a-search-result__box__detail__title')).to have_content(@article1.title)

            visit root_path
            sleep(1)
            page.find('.header__search-icon').click
            sleep(1)
            page.find('.search-frame').all('.search-frame__box')[5].all('.genre-tag')[1].click
            sleep(1)
            page.all('.search-frame__submit__btn')[1].click
            sleep(2)
            expect(page.find('.article__search-result')).to have_selector('.a-search-result__box', count: 1)
            expect(page.all('.a-search-result__box')[0].find('.a-search-result__box__detail').find('.a-search-result__box__detail__title')).to have_content(@article2.title)
        end

        it "記事タイトル&記事のジャンルで検索" do
            Capybara.current_session.driver.browser.manage.window.resize_to(1130, 720)
            page.find('.header__search-icon').click
            sleep(1)
            page.all('.s-window')[1].set @article1.title
            sleep(1)
            page.find('.search-frame').all('.search-frame__box')[5].all('.genre-tag')[0].click
            sleep(1)
            page.all('.search-frame__submit__btn')[1].click
            sleep(2)
            expect(page.find('.article__search-result')).to have_selector('.a-search-result__box', count: 1)
            expect(page.all('.a-search-result__box')[0].find('.a-search-result__box__detail').find('.a-search-result__box__detail__title')).to have_content(@article1.title)

            visit root_path
            sleep(1)
            page.find('.header__search-icon').click
            sleep(1)
            page.all('.s-window')[1].set @article2.title
            sleep(1)
            page.find('.search-frame').all('.search-frame__box')[5].all('.genre-tag')[1].click
            sleep(1)
            page.all('.search-frame__submit__btn')[1].click
            sleep(2)
            expect(page.find('.article__search-result')).to have_selector('.a-search-result__box', count: 1)
            expect(page.all('.a-search-result__box')[0].find('.a-search-result__box__detail').find('.a-search-result__box__detail__title')).to have_content(@article2.title)
            
            visit root_path
            page.find('.header__search-icon').click
            sleep(1)
            page.all('.s-window')[1].set @article1.title
            sleep(1)
            page.find('.search-frame').all('.search-frame__box')[5].all('.genre-tag')[1].click
            sleep(1)
            page.all('.search-frame__submit__btn')[1].click
            sleep(2)
            expect(page.find('.article__search-result')).to have_selector('.a-search-result__box', count: 0)

            visit root_path
            sleep(1)
            page.find('.header__search-icon').click
            sleep(1)
            page.all('.s-window')[1].set @article2.title
            sleep(1)
            page.find('.search-frame').all('.search-frame__box')[5].all('.genre-tag')[0].click
            sleep(1)
            page.all('.search-frame__submit__btn')[1].click
            sleep(2)
            expect(page.find('.article__search-result')).to have_selector('.a-search-result__box', count: 0)
        end
    end
end