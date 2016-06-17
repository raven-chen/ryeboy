class Diary
  include Mongoid::Document
  store_in collection: "Diary"
  embeds_many :comments, class_name: "LcComment"

  field :userid, type: String
  field :content, type: Hash
  field :userlevel, type: String
  field :date, type: Date
  field :createdAt, type: Time

  index "comments.userid" => 1
  index "comments.createdAt" => 1

  def score
    @diary_items ||= Ryeboy::Application.config.diary_items.map(&:with_indifferent_access)
    result = 0

    @diary_items.each do |item|
      if content[item[:value].to_s].try(:[], "check")
        result += item[:score]
      end
    end

    result
  end
end
