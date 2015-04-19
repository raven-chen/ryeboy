FactoryGirl.define do
  factory :user do |user|
    user.sequence(:email) { |n| "user#{n}@example.com" }
    user.password "password"
    user.sequence(:sno)
    user.roles ["user"]
  end

  factory :task do |task|
    task.sequence(:name) { |n| "task #{n}" }
    task.description "this is a task"
  end

  factory :comment do |c|
    c.content "test"
    c.author { create :user }
  end

  factory :exercise do
    date Date.current
    content "test"
  end
end
