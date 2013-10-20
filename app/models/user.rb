class User < ActiveRecord::Base
  DEFAULT_PASSWORD = "11111111"
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles, :address, :sno, :forum_id, :group_id, :qq,
  :tel_number, :birth_date, :note, :name

  belongs_to :group
  has_many :user_activities
  has_many :fund_exchange_activities
  has_many :fines

  has_many :tasks, :through => :exercises
  has_many :exercises, :order => "date DESC"

  validates :sno, :email, :roles, :presence => true

  before_validation do
    self.roles = ["normal"] if roles.blank?
    if password.blank?
      self.password = DEFAULT_PASSWORD
      self.password_confirmation = DEFAULT_PASSWORD
    end
  end

  ROLES = %w{admin normal gold}

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def has_task? task
    tasks.include?(task)
  end
end
