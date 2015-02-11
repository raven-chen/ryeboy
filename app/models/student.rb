class Student < ActiveRecord::Base
  attr_accessible :address, :age, :career, :comment, :gender, :group, :level, :marriage, :name, :phone_number, :qq, :exercise_url

  GENDER = ["男", "女"]
  GROUPS = ["前线", "定制", "加盟"]
  LEVELS = ["A", "B", "C", "D"]

  validates_inclusion_of :gender, in: GENDER
  validates_inclusion_of :group, in: GROUPS
  validates_inclusion_of :level, in: LEVELS

  def exercise_url= url
    url = url.strip.sub(%r|\A(http://)?| , "http://") unless url.blank?
    super url
  end
end
