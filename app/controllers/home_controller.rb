class HomeController < ApplicationController
  skip_before_filter :authenticate_user!

  def homepage
    @cases = HomepageItem.where(category: "恢复案例", view_more: false).order("sequence ASC")
    @events = HomepageItem.where(category: "最新活动", view_more: false).order("sequence ASC")
    @wechat_links = HomepageItem.where(category: "微信文章", view_more: false).order("sequence ASC")
    @newbie_link = HomepageItem.where(category: "新手链接", view_more: false).order("sequence ASC").first

    @cases_view_more_link = HomepageItem.where(category: "恢复案例", view_more: true).first
    @events_view_more_link = HomepageItem.where(category: "最新活动", view_more: true).first
    @wechats_view_more_link = HomepageItem.where(category: "微信文章", view_more: true).first
  end
end
