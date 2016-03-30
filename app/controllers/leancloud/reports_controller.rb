class Leancloud::ReportsController < ApplicationController
  load_and_authorize_resource :lc_user

  def index
    @total_users = AV::Query.new("_User").tap { |u| u.limit = 0; u.count = 1 }.get["count"]
    @total_diaries = AV::Query.new("Diary").tap { |d| d.limit = 0; d.count = 1 }.get["count"]

    @daily_diariees = [[],[]]
    @daily_new_users = [[],[]]
    (10.days.ago.to_date..Date.today).each do |date|
      @daily_diariees[0] << date
      @daily_new_users[0] << date

      @daily_diariees[1] << diaries_in_day(date)
      @daily_new_users[1] << new_users_in_day(date)
    end
  end


  def diaries_in_day date
    diaries = AV::Query.new("Diary")
    diaries.greater_eq("createdAt", AV::Date.new(date.beginning_of_day))
    diaries.less_eq("createdAt", AV::Date.new(date.end_of_day))
    diaries.count = 1
    diaries.limit = 0
    diaries.get["count"]
  end

  def new_users_in_day date
    users = AV::Query.new("_User")
    users.greater_eq("createdAt", AV::Date.new(date.beginning_of_day))
    users.less_eq("createdAt", AV::Date.new(date.end_of_day))
    users.count = 1
    users.limit = 0
    users.get["count"]
  end
end
