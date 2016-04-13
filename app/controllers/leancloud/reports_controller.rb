class Leancloud::ReportsController < ApplicationController
  load_and_authorize_resource :lc_user

  def index
    @total_users = LcUser.count
    @total_diaries = Diary.count

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
    Diary.where(createdAt: (date.beginning_of_day..date.end_of_day)).count
  end

  def new_users_in_day date
    LcUser.where(createdAt: (date.beginning_of_day..date.end_of_day)).count
  end
end
