class Image < ActiveRecord::Base
  attr_accessible :attachment
  has_attached_file :attachment, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, :attributes => :attachment, :less_than => 2.megabytes
end
