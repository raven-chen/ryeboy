class User < ActiveRecord::Base
  has_soft_deletion :default_scope => true

  TAG_TYPES = ["skill", "hobby", "personality"]
  TAG_TYPES_IN_PLURAL = [:skills, :hobbies, :personalities]
  acts_as_tagger
  acts_as_taggable
  acts_as_taggable_on TAG_TYPES_IN_PLURAL

  devise :database_authenticatable, :rememberable, :trackable, :validatable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles, :address, :sno, :group_id, :qq,
  :tel_number, :birth_date, :note, :name, :real_name, :education_experience, :work_experience, :favorite, :available_time, :duty,
  :gender

  belongs_to :group
  has_many :user_activities
  has_many :comments, :foreign_key => :author_id

  has_many :my_tasks, :class_name => "Task", :through => :user_tasks, :source => :task
  has_many :user_tasks

  has_many :tasks, :through => :exercises
  has_many :exercises, :order => "date DESC"
  has_many :topics, :foreign_key => :author_id

  has_many :liked_exercises, :through => :interests, :class_name => "Exercise", :source => :exercise, :dependent => :destroy
  has_many :interests

  ROLES = %w{newbie student mentor admin documenter hr}
  ROLES_MAP = {newbie: "新人", student: "学员", mentor: "学长", admin: "管理员", documenter: "文档管理员", hr: "人力管理"}

  LEVELS = %w{bronze silver gold platinum super}
  DUTIES = %w{招生 大一 大二 大三 大四 女子 传媒 人力}
  GENDER = ["男", "女"]

  # visible means user exclude web master
  scope :visible, where("level <> ? OR level IS NULL", "super")
  scope :with_role, lambda { |role| { conditions: "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }

  validates :sno, :presence => true, :if => lambda{|user| user.roles.exclude?("newbie")}
  validates :email, :roles, :presence => true
  validates_uniqueness_of :sno, allow_nil: true
  validates_inclusion_of :level, in: LEVELS, allow_nil: true
  validates_inclusion_of :duty, in: DUTIES, allow_nil: true
  validates_inclusion_of :gender, in: GENDER, allow_nil: true

  before_validation { |user|
    if user.roles.blank?
      user.roles = ["newbie"]
    end
  }

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  ROLES.each do |role|
    define_method("#{role}?") {
      roles.include?(role)
    }
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
end
