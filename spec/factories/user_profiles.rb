require "date"
FactoryGirl.define do
  factory :userProfile do
    sex              0
    work_place       0
    job              0
    specialized_field     0
    location              0
    birthday do
      Date.new(1989,2,30);
    end
    association :user
  end

  factory :userProfile2, class: UserProfile do
    sex              0
    work_place       0
    job              0
    specialized_field     0
    location              0
    birthday do
      Date.new(1989,1,2);
    end
    association :user
  end
end
