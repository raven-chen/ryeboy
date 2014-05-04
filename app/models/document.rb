class Document < ActiveRecord::Base
  attr_accessible :author_id, :content, :name

  belongs_to :author, :class_name => "User", :foreign_key => :author_id

  validates :name, :content, :presence => true
end
