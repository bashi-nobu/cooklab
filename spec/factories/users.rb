FactoryGirl.define do

  factory :user do
    name              "abe"
    email                 "kkk@gmail.com"
    password              "00000000"
    password_confirmation "00000000"
  end

  factory :user2, class: User do
    name              "abe"
    email                 "kkk@gmail.com"
    password              "00000000"
    password_confirmation "00000000"
    after(:build) do |user, evaluator|
      build(:userProfile, user: user)
    end
  end

   factory :user3, class: User do
    name              "abe"
    email                 "kkk@gmail.com"
    password              "00000000"
    password_confirmation "00000000"
    after(:build) do |user, evaluator|
      build(:userProfile2, user: user)
    end
  end
end
