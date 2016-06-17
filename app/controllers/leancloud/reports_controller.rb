class Leancloud::ReportsController < ApplicationController
  load_and_authorize_resource :lc_user

  def index
    @start_date = params[:start_date].try(:to_date) || 10.days.ago.to_date
    @end_date = params[:end_date].try(:to_date) || Date.today

    @total_users = LcUser.count
    @total_diaries = Diary.count

    @daily_diariees = [[],[]]
    @daily_new_users = [[],[]]
    @daily_login_users = [[],[]]
    (@start_date..@end_date).each do |date|
      @daily_diariees[0] << date
      @daily_new_users[0] << date
      @daily_login_users[0] << date

      @daily_diariees[1] << diaries_in_day(date)
      @daily_new_users[1] << new_users_in_day(date)
      @daily_login_users[1] << login_users_in_day(date)
    end
  end

  def diaries_in_day date
    Diary.where(createdAt: (date.beginning_of_day.utc..date.end_of_day.utc)).count
  end

  def new_users_in_day date
    LcUser.where(createdAt: (date.beginning_of_day.utc..date.end_of_day.utc)).count
  end

  def login_users_in_day date
    Leancloud::Report.where(date: date).first.try(:login_count) || 0
  end

  # [
  #    [user1, count_in_date1, count_in_date2],
  #    [user2, count_in_date1, count_in_date2]
  # ]
  def mentor
    @start_date = params[:start_date].try(:to_date) || 3.days.ago.to_date
    @end_date = params[:end_date].try(:to_date) || Date.today

    @mentors = LcUser.where(:level.gte => LcUser::LEVEL_MAP['实习学长'])
    @mentors = @mentors.find(params[:mentor_ids]) if params[:mentor_ids]

    @results = []
    @mentors.each do |mentor|
      one_user_result = [mentor.username]
      total = 0

      (@start_date..@end_date).each do |date|
        comments_in_day = replied_comments_count(mentor, date)
        total += comments_in_day
        one_user_result << comments_in_day
      end

      one_user_result << total

      @results << one_user_result
    end

    @results.sort!{|a,b| a[-1] <=> b[-1]}.reverse! # Sort by total
  end

  def diaries
    @results = []

    levels = ["预科", "大一", "大二", "大三", "大四"]

    dates = (7.days.ago.to_date..Date.today).to_a

    @results << (["日期"] + dates)

    levels.each do |level|
      @results << [level]

      users = LcUser.where(level: LcUser::LEVEL_MAP[level])
      related_diaries = Diary.where(:userid => { "$in" => users.map{|u| u.id.to_s} }, :date.gte => 7.days.ago.to_date).map{|diary| [diary.userid, diary.date, diary.score]}

      users.each do |user|
        @results << [user.name] + dates.map{ |date| dairy_in_date(related_diaries, user, date) }
      end
    end
  end

  private
  def replied_comments_count mentor, date
    Diary.where({
      comments: { "$elemMatch" => {createdAt: (date.beginning_of_day.utc..date.end_of_day.utc), userid: mentor.id.to_s} }
    }).count
  end

  def dairy_in_date related_diaries, user, date
    diary = related_diaries.select{ |diary| diary[0] == user.id.to_s && diary[1] == date }.flatten

    if diary.empty?
      "<span class='text-danger'>否</span>"
    else
      "<span class='text-success'>#{diary[2]}</span>"
    end
  end
end
