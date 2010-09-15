# == Schema Information
#
# Table name: data_responses
#
#  id                               :integer         not null, primary key
#  data_element_id                  :integer
#  data_request_id                  :integer
#  complete                         :boolean         default(FALSE)
#  created_at                       :datetime
#  updated_at                       :datetime
#  organization_id_responder        :integer
#  currency                         :string(255)
#  fiscal_year_start_date           :date
#  fiscal_year_end_date             :date
#  contact_name                     :string(255)
#  contact_position                 :string(255)
#  contact_phone_number             :string(255)
#  contact_main_office_phone_number :string(255)
#  contact_office_location          :string(255)
#

require 'lib/ActAsDataElement'

class DataResponse < ActiveRecord::Base

  # Validations
  validates_date :fiscal_year_start_date
  validates_date :fiscal_year_end_date
  #validate :validate_start_date_and_end_date, :unless => Proc.new { |model| model.fiscal_year_start_date.blank? && model.fiscal_year_end_date.blank? }
  validates_presence_of :currency

  named_scope :available_to, lambda { |current_user|
    if current_user.role?(:admin)
      {}
    else
      {:conditions=>{:organization_id_responder => current_user.organization.id}}
    end
  }

#  has_many :data_elements, :dependent=>:destroy
  has_many :users_currently_completing, :class_name => "User",
    :foreign_key => :data_response_id_current

  belongs_to :responding_organization, :class_name => "Organization",
    :foreign_key => "organization_id_responder"

  belongs_to :data_request

  def self.remove_security
    with_exclusive_scope {find(:all)}
  end

  named_scope :unfulfilled, :conditions => ["complete = ?", false]

  private

  def validate_start_date_and_end_date
    errors.add(:base, "Start date must come before End date.") unless self.fiscal_year_start_date < self.fiscal_year_end_date
  end

end
