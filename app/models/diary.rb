class Diary
  include Mongoid::Document
  store_in collection: "Diary"
  field :userid, type: String
  field :userlevel, type: String
  field :date, type: Date
  field :createdAt, type: Time
end
