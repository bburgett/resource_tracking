class User < ActiveRecord::Base
  acts_as_authentic

  has_many  :assignments

  validates_presence_of  :username, :email
  validates_uniqueness_of :email, :case_sensitive => false
  validates_confirmation_of :password, :on => :create
  validates_length_of :password, :within => 8..64, :on => :create

  named_scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0 "} }

  ROLES = %w[admin reporter]


  def deliver_password_reset_instructions!
     reset_persistence_token!
     Notifier.deliver_password_reset_instructions(self)
  end

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    roles.include? role.to_s
  end

  def organization
    Organization.find_by_name("self")
  end
  def self.organization
    Organization.find_by_name("self")
  end

end

