FactoryGirl.define do
  factory :testuser, class: User do
  	name { 'capybara' }
    email { 'sp2h5vb9@yahoo.co.jp' }
    password { '00000000' }
    password_confirmation { "00000000" }
    confirmed_at { Time.now }
  end
end