source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.0'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.6.0'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

gem 'haml-rails'
gem 'erb2haml'
gem 'jquery-rails'
gem "jquery-slick-rails"
gem 'jquery-ui-rails'
gem 'font-awesome-rails'

# active admin
gem 'activeadmin'
gem 'devise'
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'

# config
gem 'config'

# Pay.jp
gem 'payjp'

# for image uploader with AWS S3
gem 'carrierwave'
gem 'fog-aws'

# ckeditor(rich text)
gem 'mini_magick'
gem 'ckeditor', '4.2.4'

# flora(rich text)
# gem 'activeadmin_froala_editor'

# page nation
gem 'kaminari'

# tag
gem 'acts-as-taggable-on'

# search
gem 'ransack'

# chartkick
gem "chartkick"

# japanese
gem 'rails-i18n'

# static page
gem 'high_voltage'

# Google Analytics
gem 'google-analytics-rails'

# meta-tag seo対策
gem 'meta-tags'

# Manage crontab
gem 'whenever', require: false

# maintenance
gem 'turnout'

# Google Adsense
gem 'rack-cors'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'webdrivers'
  gem 'selenium-webdriver'
  gem 'pry-rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'factory_girl_rails', "~> 4.4.1"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors'
  # code-review-tool
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'rubocop', require: false
end

group :deployment do
  # cron management
  # gem 'whenever', require: false

  # Deploy
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano3-puma', require: false
  gem 'capistrano-rails-console' # 手元の環境からデプロイ先のconsoleを使う
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
