class Diary
  include Mongoid::Document
  store_in collection: "Diary"
  embeds_many :comments, class_name: "LcComment"

  field :userid, type: String
  field :userlevel, type: String
  field :date, type: Date
  field :createdAt, type: Time
end
