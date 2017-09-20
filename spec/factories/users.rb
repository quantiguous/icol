FactoryGirl.define do
  factory :user do 
    sequence(:email) {|n| "user#{n}@example.com" }
    sequence(:username) {|n| "user#{n}@example.com" }
    created_at 2.day.ago.to_s(:db)
    updated_at 1.day.ago.to_s(:db)
    inactive 0
  end
end
