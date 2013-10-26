class Exercise < ActiveRecord::Base
  attr_accessible :content, :date, :task_id, :user_id

  belongs_to :user
  belongs_to :task

  validates :user, :task, :date, :content, :presence => :true
  validates_uniqueness_of :date, :scope => [:user_id, :task_id]

  def self.on_date date
    where(:date => date)
  end

  def self.newest
    order("date DESC").limit(20)
  end

  def content
    read_attribute(:content).try(:html_safe)
  end
end
