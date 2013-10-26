# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do |task|
    task.sequence(:name) { |n| "task #{n}" }
    task.description "this is a task"
  end
end
