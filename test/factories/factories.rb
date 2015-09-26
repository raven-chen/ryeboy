FactoryGirl.define do
  factory :new_user, :class => User do |user|
    user.sequence(:email) { |n| "user#{n}@example.com" }
    user.sequence(:name) { |n| "user#{n}" }
    user.password "password"
  end

  factory :user do |user|
    user.sequence(:email) { |n| "user#{n}@example.com" }
    user.sequence(:name) { |n| "user#{n}" }
    user.password "password"
    user.sequence(:sno)
    user.roles ["student"]
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

  factory :topic do |t|
    t.title "test"
    t.content "test"
    t.category Topic::CATEGORIES.first
    t.association :author, factory: :user
  end

  factory :document do |t|
    t.name "test"
    t.content "test"
    t.category Document::CATEGORIES.first
    t.association :author, factory: :user
  end

  factory :post do |t|
    t.name "test"
    t.content "test"
    t.category Post::CATEGORIES.first
    t.association :author, factory: :user
  end

  factory :notification do |t|
    t.name "test notification"
    t.content "test notification"
    t.category Notification::CATEGORIES.first
    t.active true
  end
end
