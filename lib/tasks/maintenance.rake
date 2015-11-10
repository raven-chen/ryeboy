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

desc "Init homepage"
task :initialize_homepage => :environment do
  HomepageItem.create(category: "新手链接", name: "【新人指南】—— 新人第一步怎么做", url: "http://bbs.ryeboy.org/topics/192", sequence: 1)

  HomepageItem.create(category: "最新活动", name: "【分享】启航YY录音，助你开启麦田恢复之旅！", url: "http://bbs.ryeboy.org/tasks/49", sequence: 1)
  HomepageItem.create(category: "最新活动", name: "【报名】麦田教学报名帖，等待你的加入！", url: "http://bbs.ryeboy.org/tasks/52", sequence: 2)
  HomepageItem.create(category: "最新活动", name: "【调查】麦田APP建议征集 ", url: "http://bbs.ryeboy.org/tasks/24", sequence: 3)

  HomepageItem.create(category: "恢复案例", name: "阿林 — 10年慢前的康复之路", url: "http://bbs.ryeboy.org/topics/247", sequence: 1)
  HomepageItem.create(category: "恢复案例", name: "自强 — 苦B大学生8年邪淫路 （关键字：大学生、精神萎靡、自卑绝望）", url: "http://bbs.ryeboy.org/topics/219", sequence: 2)
  HomepageItem.create(category: "恢复案例", name: "空白 — 行尸走肉成铁骨男儿 （关键字：慢性肾炎6年）", url: "http://bbs.ryeboy.org/topics/248", sequence: 3)
  HomepageItem.create(category: "恢复案例", name: "雨夜-从黄，赌，毒，邪淫14年的慢慢重生！", url: "http://bbs.ryeboy.org/topics/249", sequence: 4)
  HomepageItem.create(category: "恢复案例", name: "诚恩 — 打破10天的破戒魔咒 （关键字：20年前列腺、昏沉无力、失眠自闭）", url: "http://bbs.ryeboy.org/topics/250", sequence: 5)
end
