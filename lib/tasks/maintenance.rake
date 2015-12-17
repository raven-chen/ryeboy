task :migrate_topic_category => :environment do
  Topic.where(category: "青春励志").update_all(category: "蜕变案例")
  Topic.where(category: "资料分享").update_all(category: "精品微信")
  Topic.where("category NOT IN (?)", Topic::CATEGORIES).update_all(category: "问题求助")
end
