task :migrate_data => :environment do
  Post.where(category: "教研部").update_all(category: "教学部")
end

# 新生 改 新人
# 增加新年级 预科
# 从大四开始 所有学员降一级, 除了新生

task :migrate_user_grade => :environment do
  User.where(grade: "新生").update_all(grade: "新人")
  User.where(grade: "大一").update_all(grade: "预科")
  User.where(grade: "大二").update_all(grade: "大一")
  User.where(grade: "大三").update_all(grade: "大二")
  User.where(grade: "大四").update_all(grade: "大三")
end
