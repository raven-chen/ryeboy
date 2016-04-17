class Leancloud::ReportsController < ApplicationController
  load_and_authorize_resource :lc_user

  def index
    @start_date = params[:start_date].try(:to_date) || 10.days.ago.to_date
    @end_date = params[:end_date].try(:to_date) || Date.today

    @total_users = LcUser.count
    @total_diaries = Diary.count

    @daily_diariees = [[],[]]
    @daily_new_users = [[],[]]
    (@start_date..@end_date).each do |date|
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

  # [
  #    [user1, count_in_date1, count_in_date2],
  #    [user2, count_in_date1, count_in_date2]
  # ]
  def mentor
    @start_date = params[:start_date].try(:to_date) || 10.days.ago.to_date
    @end_date = params[:end_date].try(:to_date) || Date.today

    mentors = LcUser.where(:level.gte => LcUser::LEVEL_MAP['实习学长'])
    @results = []

    mentors.each do |mentor|
      mentor_detail = [mentor.username]

      (@start_date..@end_date).each do |date|
        mentor_detail << replied_comments_count(mentor, date)
      end

      @results << mentor_detail
    end
  end

  private

  def replied_comments_count mentor, date
    Diary.where({ createdAt: {"$gte" => @start_date}, comments: {"$elemMatch" => {createdAt: (date.beginning_of_day..date.end_of_day), userid: mentor.id} }}).count
  end

end
