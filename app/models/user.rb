# == Schema Information
#
# Table name: users
#
#  id                       :integer         not null, primary key
#  username                 :string(255)
#  email                    :string(255)
#  crypted_password         :string(255)
#  password_salt            :string(255)
#  persistence_token        :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  roles_mask               :integer
#  organization_id          :integer
#  data_response_id_current :integer
#  text_for_organization    :text
#

class User < ActiveRecord::Base
  acts_as_authentic

  #cattr_accessor :current_user
  attr_readonly :roles_mask #only assign role on create
  attr_readonly :organization_id #only assign organization on create

  before_save :authorize

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

  def roles=(roles)
    roles = roles.collect {|r| r.to_s} # allows symbols to be passed in
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    roles.include? role.to_s
  end

  def to_s
    username
  end

  def self.stub_current_user_and_data_response
    # stub the authorize instance method 
    o=Organization.new(:name=>"org_for_internal_stub382342")
    o.save(false)
    u = User.new(:username=> "admin_internal_stub2309420", :roles => ["admin"],
      :organization => o)
    u.save(false)
    # unstub the authorize method

    # stub current user after saving the original method
    # alternative is to set a flag and use that in the current_user method
    # to return a @@current_user
    User.current_user = u
    d=DataResponse.new :responding_organization => o
    d.save(false)
    u.current_data_response = d
    u.save(false)
    User.current_user = u
    # todo - hide the hold method and replace it w shortcut to these vars
    # then show on the unstub
  end
  def self.unstub_current_user_and_data_response
    u=User.find_by_username("admin_internal_stub2309420")
    u.try(:current_data_response).try(:delete)
    o = Organization.find_by_name("org_for_internal_stub382342")
    o.try(:delete)
    u.try(:delete)
    User.current_user = nil
  end
  def authorize
    # can't stub user with this...
    # routes should stop access / saving
#    unless User.current_user.id == self.id || User.current_user.try(:role?,:admin)
#      raise CanCan::AccessDenied
#    end
  end

  def self.current_user
    @@current_user = current_user_session && current_user_session.record
  end

  protected

  def self.current_user_session
    @@current_user_session = UserSession.find
  end
end

