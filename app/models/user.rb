class User < ActiveRecord::Base
  acts_as_authentic

  cattr_accessor :current_user
  attr_readonly :roles_mask #only assign role on create

  has_many  :assignments
  belongs_to :organization
  has_many :data_responses, :through => :organization

  belongs_to :current_data_response, :class_name => "DataResponse",
    :foreign_key => :data_response_id_current

  validates_presence_of  :username, :email
  validates_uniqueness_of :email, :case_sensitive => false
  validates_confirmation_of :password, :on => :create
  validates_length_of :password, :within => 8..64, :on => :create

  named_scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0 "} }

  def self.remove_security
    with_exclusive_scope {find(:all)}
  end

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

  # GR: why is this needed ?
  # GN: was stubbing User.current_user.organization
  def self.organization
    current_user.organization
  end

  def self.stub_current_user_and_data_response
    o=Organization.new(:name=>"org_for_internal_stub382342")
    o.save(false)
    u = User.new(:username=> "admin_internal_stub2309420", :roles => [:admin],
      :organization => o)
    u.save(false)
    User.current_user = u
    d=DataResponse.new :responding_organization => o
    d.save(false)
    u.current_data_response = d
    u.save(false)
    User.current_user = u
  end
  def self.unstub_current_user_and_data_response
    u=User.find_by_username("admin_internal_stub2309420")
    u.current_data_response.delete
    Organization.delete(Organization.find_by_name("org_for_internal_stub382342").id)
    User.delete(User.find_by_username("admin_internal_stub2309420").id)
    User.current_user = nil
  end

end

