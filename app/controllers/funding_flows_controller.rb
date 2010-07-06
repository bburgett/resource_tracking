class FundingFlowsController < ApplicationController
  @@shown_columns = [:from, :to,  :project]
  @@create_columns = [:from, :to,  :project, :spend_q1, :spend_q2, :spend_q3, :spend_q4, :budget_q1, :budget_q2, :budget_q3, :budget_q4]
  @@columns_for_file_upload = @@shown_columns.map {|c| c.to_s} # TODO extend feature, locations for instance won't work

  map_fields :create_from_file,
    @@columns_for_file_upload,
    :file_field => :file
  
  active_scaffold :funding_flow do |config|
    config.columns =  @@shown_columns
    list.sorting = {:from => 'DESC'}

    config.nested.add_link("Comments", [:comments])
    config.columns[:comments].association.reverse = :commentable

    config.create.columns = @@create_columns
    config.update.columns = config.create.columns
    [:from, :to, :project].each do |c|
      config.columns[c].form_ui = :select
      config.columns[c].inplace_edit = :ajax
    end
    config.columns[:committment_to].inplace_edit = true
    config.columns[:disbursement_to].inplace_edit = true
    config.columns[:spending_to].inplace_edit = true
    [:committment_to, :disbursement_to]. each do |c|
      config.columns[c].label = c.to_s.split("_").first.capitalize + " from donor"
    end
    config.columns[:spending_to].label = "Amount Spent"
    [:spend_q1, :spend_q2, :spend_q3, :spend_q4].each do |c|
      config.columns[c].inplace_edit = true
      config.columns[c].label = "Calender 2009-2010 "+c.to_s.humanize.sub("q","Q")
    end
    [:budget_q1, :budget_q2, :budget_q3, :budget_q4].each do |c|
      config.columns[c].inplace_edit = true
      config.columns[c].label = "Calender 2010-2011 "+c.to_s.humanize.sub("q","Q")
    end
  end

  def funding_sources
    @constraints = { :to => Organization.last.id } #current_user.organization.id
    @label = "Funding Sources"
    index_w_constraints
  end

  def providers
    @constraints = { :from => Organization.last.id } #current_user.organization.id
    @label = "Providers"
    index_w_constraints
  end

  def create_from_file
    super @@columns_for_file_upload
  end

  def test
    @organization=Organization.first
  end

  protected

  def index_w_constraints
    session[:last_data_entry_constraints] = @constraints
    data_entry
  end
end
