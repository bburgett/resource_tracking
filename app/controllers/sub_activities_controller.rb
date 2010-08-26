class SubActivitiesController < ActiveScaffoldController

  authorize_resource :class => Activity

  before_filter :check_user_has_data_response

  @@shown_columns = [ :provider, :budget, :budget_percentage, :spend, :spend_percentage]
  @@create_columns = [:provider,  :budget, :budget_percentage, :spend, :spend_percentage]
  def self.create_columns
    @@create_columns
  end
  @@columns_for_file_upload = %w[provider budget spend]

  map_fields :create_from_file,
    @@columns_for_file_upload,
    :file_field => :file

  active_scaffold :sub_activities do |config|
    config.label =  "Sub Implementers"
    config.columns =  @@shown_columns
    list.sorting = {:budget => 'DESC'} #adding this didn't break in place editing

    config.action_links.add('Upload',
      :action => "create_from_file_form",
#      :controller => "sub_activities",
      :type => :collection,
      :popup => true,
      :inline => true,
      :position => :top,
      :label => "Upload")

    config.nested.add_link("Comments", [:comments])
    config.columns[:comments].association.reverse = :commentable

    config.create.columns = @@create_columns
    config.update.columns = @@create_columns
    config.columns[:provider].form_ui             = :select
    config.columns[:provider].label               = "Implementer"
    config.columns[:budget].label = "Budget GOR FY 10-11"
    config.columns[:spend].label = "Spend GOR FY 09-10"
    [:spend, :budget].each do |c|
      quarterly_amount_field_options config.columns[c]
      config.columns[c].inplace_edit = true
      c=c.to_s
      quarterly_amount_field_options config.columns[c+"_percentage"]
      config.columns[c+"_percentage"].inplace_edit = true
      config.columns[c+"_percentage"].label = "% of Main Activity's #{c.capitalize}"
    end
    [config.update.columns, config.create.columns].each do |columns|
      columns.add_subgroup "Budget" do |budget_group|
        budget_group.add :budget, :budget_percentage
      end
      columns.add_subgroup "Expenditures" do |funds_group|
        funds_group.add :spend, :spend_percentage
      end
    end
    #    %w[q1 q2 q3 q4].each do |quarter|
    #      c = "spend_"+quarter
    #      c = c.to_sym
    #      config.columns[c].inplace_edit = true
    #      quarterly_amount_field_options config.columns[c]
    #      config.columns[c].label = "Expenditure in Your FY 09-10 "+quarter.capitalize
    #    end
    #    config.columns[:spend_q4_prev].inplace_edit = true
    #    quarterly_amount_field_options config.columns[:spend_q4_prev]
    #    config.columns[:spend_q4_prev].label = "Expenditure in your FY 08-09 Q4"
  end

  def create_from_file_form
    super "sub-activities"
  end

  def create_from_file
    # TODO somehow get constraints so we have right parent id
    # store in session?
    @constraints = { :activity => "?" }
    super @@columns_for_file_upload
  end

  def beginning_of_chain
    super.available_to current_user
  end
  #fixes create
  def before_create_save record
    record.data_response = current_user.current_data_response
  end
end
