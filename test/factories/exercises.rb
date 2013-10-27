# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exercise do
    date Date.current
    content "test"
  end
end
