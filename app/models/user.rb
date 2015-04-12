class User < ActiveRecord::Base
  has_soft_deletion :default_scope => true

  devise :database_authenticatable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles, :address, :sno, :forum_id, :group_id, :qq,
  :tel_number, :birth_date, :note, :name

  belongs_to :group
  has_many :user_activities
  has_many :fund_exchange_activities
  has_many :fines
  has_many :comments, :foreign_key => :author_id

  has_many :my_tasks, :class_name => "Task", :through => :user_tasks, :source => :task
  has_many :user_tasks

  has_many :tasks, :through => :exercises
  has_many :exercises, :order => "date DESC" do
    def finished_on_date date
      where("date = ? AND created_at <= ?", date, User.valid_exercise_log_date(date))
    end
  end
  has_many :topics, :foreign_key => :author_id

  has_many :liked_exercises, :through => :interests, :class_name => "Exercise", :source => :exercise, :dependent => :destroy
  has_many :interests

  ROLES = %w{master admin user documenter}
  LEVELS = %w{bronze silver gold platinum}

  validates :sno, :email, :roles, :presence => true
  validates_uniqueness_of :sno
  validates_inclusion_of :level, in: LEVELS

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  # The only one master :p
  # The reason why not define this as a scope is it has been used in another scope and the result of this one is not chain-able.
  def self.master
    where(:sno => "0").first
  end

  def master?
    self.id == User.master.id
  end

  def has_task? task
    my_tasks.include?(task)
  end

  def self.valid_exercise_log_date date
    date.tomorrow.to_datetime + 18.hours # Exercise must be logged before next day's 18pm
  end
end
