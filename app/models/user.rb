class User < ActiveRecord::Base
  has_soft_deletion :default_scope => true

  DEFAULT_PASSWORD = "99999999"
  TAG_TYPES = ["skill", "hobby", "personality"]
  TAG_TYPES_IN_PLURAL = [:skills, :hobbies, :personalities]
  acts_as_tagger
  acts_as_taggable
  acts_as_taggable_on TAG_TYPES_IN_PLURAL

  devise :database_authenticatable, :rememberable, :trackable, :validatable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles, :address, :sno, :group_id, :qq,
  :tel_number, :birth_date, :note, :name, :real_name, :education_experience, :work_experience, :favorite, :available_time, :grade,
  :gender, :department, :sub_department, :read_new_notices_at, :read_new_features_at

  belongs_to :group
  has_many :user_activities
  has_many :comments, :foreign_key => :author_id, dependent: :destroy
  has_many :posts, :foreign_key => :author_id, dependent: :destroy

  has_many :my_tasks, :class_name => "Task", :through => :user_tasks, :source => :task
  has_many :user_tasks

  has_many :tasks, :through => :exercises
  has_many :exercises
  has_many :topics, :foreign_key => :author_id
  has_many :replies, :foreign_key => :author_id

  has_many :liked_exercises, :through => :interests, :class_name => "Exercise", :source => :exercise, :dependent => :destroy
  has_many :interests

  ROLES = %w{newbie student mentor admin documenter hr dean}
  ROLES_MAP = {newbie: "新人", student: "学员", mentor: "学长", admin: "管理员", documenter: "文档管理员", hr: "人力管理", dean: "教务长"}

  DEPARTMENTS = %w{招生 大一 大二 大三 大四 女子 传媒 人力}
  GRADES = %w{新生 大一 大二 大三 大四 女子 学长}

  GENDER = ["男", "女"]
  NEWBIE_TASK_NAME = "自学一星"

  scope :with_role, lambda { |role| { conditions: "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }
  scope :without_role, lambda { |role| { conditions: "roles_mask & #{2**ROLES.index(role.to_s)} = 0"} }

  def self.visible
    without_role("admin")
  end

  validates :sno, :presence => true, :if => lambda{|user| user.roles.exclude?("newbie")}
  validates :email, :name, :roles, :presence => true
  validates_uniqueness_of :sno, allow_nil: true
  validates_inclusion_of :department, in: DEPARTMENTS, allow_blank: true
  validates_inclusion_of :sub_department, in: DEPARTMENTS, allow_blank: true
  validates_inclusion_of :grade, in: GRADES, allow_blank: true
  validates_inclusion_of :gender, in: GENDER, allow_blank: true

  before_validation { |user|
    if user.roles.blank?
      user.roles = ["newbie"]
    end
  }

  before_create { |user|
    user.grade = GRADES[0] if user.grade.blank? && user.newbie?
  }

  after_create { |user|
    # Set task for newbie
    # TODO: Better to have a column instead of this magic string
    if user.newbie?
      newbie_task = Task.find_by_name(NEWBIE_TASK_NAME)
      user.my_tasks << newbie_task if newbie_task
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

  def has_task? task
    my_tasks.include?(task)
  end

  def generalized_mentor?
    (["mentor", "admin", "hr"] & roles).size != 0
  end

  # High grade could view lower grade, instead lower grade could not view higher
  def visible_grades
    if generalized_mentor?
      GRADES
    else
      current_grade_index = GRADES.index(grade) || 0
      GRADES[0..current_grade_index]
    end
  end
end
