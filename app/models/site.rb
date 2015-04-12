class Site < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  # Site should be one of user level
  validates_inclusion_of :name, in: User::LEVELS

  def self.users
    User.where(level: current_site.name)
  end

  def self.current_site
    raise "Site not configured !" if Site.count != 1
    Site.first
  end
end
