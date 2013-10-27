class Exercise < ActiveRecord::Base
  attr_accessible :content, :date, :task_id, :user_id

  belongs_to :user
  belongs_to :task

  validates :user, :task, :date, :content, :presence => :true
  validates_uniqueness_of :date, :scope => [:user_id, :task_id]

  def copy_content_from_previous_one
    self.content = previous_one.content if previous_one
  end

  def self.on_date date
    where(:date => date)
  end

  def self.newest
    order("date DESC").limit(20)
  end

  def previous_one
    self.class.where(:user_id => user_id, :task_id => task_id).order("date DESC").limit(1).try(:first)
  end

  def content
    read_attribute(:content).try(:html_safe)
  end
end
