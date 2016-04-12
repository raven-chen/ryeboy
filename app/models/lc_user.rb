class LcUser
  include Mongoid::Document
  store_in collection: "User"
  field :email, type: String
  field :username, type: String
  field :level, type: String
  field :password, type: String
  field :createdAt, type: Time

  LEVEL_MAP = {"新手" => "10", "预科" => "15", "大一" => "20", "大二" => "30", "大三" => "40", "大四" => "50",
               "实习学长" => "60", "认证学长" => "70", "资深学长" => "80"}
end
