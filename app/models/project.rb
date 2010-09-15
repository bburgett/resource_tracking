# == Schema Information
#
# Table name: projects
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  description      :text
#  start_date       :date
#  end_date         :date
#  created_at       :datetime
#  updated_at       :datetime
#  budget           :decimal(, )
#  spend            :decimal(, )
#  entire_budget    :decimal(, )
#  currency         :string(255)
#  spend_q1         :decimal(, )
#  spend_q2         :decimal(, )
#  spend_q3         :decimal(, )
#  spend_q4         :decimal(, )
#  spend_q4_prev    :decimal(, )
#  data_response_id :integer
#

require 'lib/acts_as_stripper' #TODO move
require 'lib/ActAsDataElement'

class Project < ActiveRecord::Base
  acts_as_commentable

  include ActAsDataElement
  include ActsAsDateChecker
  configure_act_as_data_element

  acts_as_stripper
  has_and_belongs_to_many :activities
  has_and_belongs_to_many :locations
  has_many :funding_flows #, :dependent => :nullify

  has_many :funding_sources, :through => :funding_flows, :class_name => "Organization", :source => :from
  has_many :providers, :through => :funding_flows, :class_name => "Organization", :source => :to

  # Validations
  validates_presence_of :name
  validates_numericality_of :spend, :if => Proc.new {|model| !model.spend.blank?}
  validates_numericality_of :budget, :if => Proc.new {|model| !model.budget.blank?}
  validates_numericality_of :entire_budget, :if => Proc.new {|model| !model.entire_budget.blank?}
  validates_date :start_date
  validates_date :end_date
  validate :validate_start_date_and_end_date, :if => Proc.new { |model| model.start_date.present? && model.end_date.present? }

  attr_accessible :name, :description, :spend, :budget, :entire_budget,
                  :start_date, :end_date, :currency

  after_create :create_helpful_records_for_workflow

  def organization
    self.data_response.responding_organization
  end

  def spend=(amount)
    super(strip_non_decimal(amount))
  end

  def budget=(amount)
    super(strip_non_decimal(amount))
  end

  def entire_budget=(amount)
    super(strip_non_decimal(amount))
  end

  def to_s
    result = ''
    result = name unless name.nil?
    result
  end

  # TODO... GR: this is view code - must be moved out of the model
  def to_label #so text doesn't spill over in nested scaffs.
      to_s
  end

  # this is an AS helper, and currently only seems to be used by activity scaffold.
  # todo - test this - then refactor
  # GN: looks like this isn't being used at all for now
  # let's take it out soon when we have more test coverage
  def valid_providers
    f=funding_flows.find(:all, :select => "organization_id_to",
      :conditions =>
      ["organization_id_from = ?", owner.id])

    r=f.collect {|f| f.organization_id_to}
    r
  end

  def create_helpful_records_for_workflow
    my_org = owner
    #puts "this is my org:"+my_org.inspect
    #TODO pass in the amount attributes and use them on records below
    #attribs = r.attributes.reject {|a| ! FundingFlow.new.attributes.include? a }
    shared_attributes = [:budget, :spend, :spend_q4_prev, :spend_q1, :spend_q2, :spend_q3, :spend_q4, :data_response]
    f1=funding_flows.create({:to => my_org})
    f2=funding_flows.create({:from => my_org, :to => my_org, :self_provider_flag => 1})
    shared_attributes.each do |att|
      f1.send(att.to_s+"=", self.send(att))
      f2.send(att.to_s+"=", self.send(att))
    end
    f1.save;f2.save;
    #activities << OtherCost.new #TODO fix and let this work
  end

  private

  def validate_start_date_and_end_date
    start_date = string_validator.string_to_date(self.start_date)
    end_date   = string_validator.string_to_date(self.end_date)
    errors.add(:base, "Start date must come before End date.") unless start_date < end_date
  end

end
