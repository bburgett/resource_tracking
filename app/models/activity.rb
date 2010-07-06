class Activity < ActiveRecord::Base
  acts_as_commentable
  has_and_belongs_to_many :projects 
  has_and_belongs_to_many :indicators
  has_many :lineItems
  belongs_to :provider, :foreign_key => :provider_id, :class_name => "Organization"

  has_many :code_assignments
  has_one :mtef, :through => :code_assignments, :source => :code, :source_type => "Mtef"
  has_one :nsp, :through => :code_assignments,:source => :code,  :source_type => "Nsp"
  has_one :nha, :through => :code_assignments, :source => :code, :source_type => "Nha"
  has_one :nasa, :through => :code_assignments, :source => :code, :source_type => "Nasa"
  validates_presence_of :name
end
