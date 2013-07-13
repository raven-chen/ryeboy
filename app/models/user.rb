class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles, :address, :sno, :forum_id, :group_id, :qq,
  :tel_number, :birth_date, :note

  belongs_to :group
  has_many :user_activities
  has_many :fund_exchange_activities
  has_many :fines

  validates :sno, :email, :roles, :presence => true

  before_save do
    self.roles = ["normal"] if roles.blank?
  end

  ROLES = %w{admin normal}

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end
end
