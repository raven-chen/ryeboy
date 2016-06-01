task collect_daily_login_count: :environment do
  date = Date.yesterday
  login_count = LcUser.where(lastFetchNoticeAt: (date.beginning_of_day.utc..date.end_of_day.utc)).count

  Leancloud::Report.create!(login_count: login_count, date: date)
end
