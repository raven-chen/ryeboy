class LcUser
  attr_accessor :objectId, :email, :username, :level

  LEVEL_MAP = {"新手" => "10", "预科" => "15", "大一" => "20", "大二" => "30", "大三" => "40", "大四" => "50",
               "实习学长" => "60", "认证学长" => "70", "资深学长" => "80"}

  def initialize params
    @objectId = params[:objectId]
    @email = params[:email]
    @username = params[:username]
    @level = params[:level]
  end
end
