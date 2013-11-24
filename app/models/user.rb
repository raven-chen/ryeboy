class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles, :address, :sno, :forum_id, :group_id, :qq,
  :tel_number, :birth_date, :note, :name

  belongs_to :group
  has_many :user_activities
  has_many :fund_exchange_activities
  has_many :fines

  has_many :my_tasks, :class_name => "Task", :through => :user_tasks, :source => :task
  has_many :user_tasks

  has_many :tasks, :through => :exercises
  has_many :exercises, :order => "date DESC" do
    def finished_on_date date
      where("date = ? AND created_at <= ?", date, User.valid_exercise_log_date(date))
    end
  end

  validates :sno, :email, :roles, :presence => true
  validates_uniqueness_of :sno

  ROLES = %w{admin normal gold discipline}

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def has_task? task
    my_tasks.include?(task)
  end

  def self.valid_exercise_log_date date
    date.tomorrow.to_datetime + 18.hours # Exercise must be logged before next day's 18pm
  end
end
