class LcComment
  include Mongoid::Document
  embedded_in :diary

  field :userid, type: String
  field :createdAt, type: Time
  field :content
end
