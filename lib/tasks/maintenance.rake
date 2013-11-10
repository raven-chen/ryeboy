task :assign_all_tasks_to_all_users => :environment do
  User.all.each do |user|
    user.my_tasks << Task.all
  end
end
