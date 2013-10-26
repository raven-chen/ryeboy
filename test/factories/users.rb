# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do |user|
    user.sequence(:email) { |n| "user#{n}@example.com" }
    user.password "password"
    user.sequence(:sno)
    user.roles ["gold"]
  end
end
