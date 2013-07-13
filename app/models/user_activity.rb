class UserActivity < ActiveRecord::Base
  attr_accessible :ask_for_leave, :note, :sign_in, :user_id

  belongs_to :user

  validates :user, :presence => true
end
