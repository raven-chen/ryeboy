task :migrate_data => :environment do
  Post.where(category: "教研部").update_all(category: "教学部")
end
