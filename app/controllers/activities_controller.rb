class ActivitiesController < ApplicationController
  authorize_resource

  @@shown_columns = [:projects, :provider, :description,  :budget  ]
  @@create_columns = [:projects, :locations, :provider, :name, :description,  :start, :end, :beneficiary, :target, :spend, :spend_q1, :spend_q2, :spend_q3, :spend_q4, :budget]
  def self.create_columns
    @@create_columns
  end
  @@columns_for_file_upload = %w[name description provider expected_total] # TODO fix bug, projects for instance won't work

  map_fields :create_from_file,
    @@columns_for_file_upload,
    :file_field => :file

  active_scaffold :activity do |config|
    config.columns =  @@shown_columns
    list.sorting = {:name => 'DESC'}

    config.action_links.add('Classify',
      :action => "code",
      :type => :member,
      :popup => true,
      :label => "Classify")

    config.nested.add_link("Cost Categorization", [:lineItems])
    config.columns[:lineItems].association.reverse = :activity

    config.nested.add_link("Comments", [:comments])
    config.columns[:comments].association.reverse = :commentable

    config.create.columns = @@create_columns
    config.update.columns = config.create.columns
    config.columns[:projects].inplace_edit = :ajax
    config.columns[:projects].form_ui = :select
    #config.columns[:projects].options[:update_column] = [:provider] #not working
    config.columns[:locations].form_ui = :select
    config.columns[:locations].label = "Districts Worked In"
    #config.columns[:locations].options[:update_column] = [:provider] #not working
    config.columns[:provider].form_ui = :select
    config.columns[:provider].association.reverse = :provider_for
    config.columns[:name].inplace_edit = true
    config.columns[:name].label = "Name (Optional)"
    config.columns[:description].inplace_edit = true
    config.columns[:target].label = "Target"
    config.columns[:beneficiary].label = "Beneficiary"

    config.columns[:spend].label = "Total Spend GOR FY 09-10"
    config.columns[:budget].label = "Total Budget GOR FY 10-11"
    [:spend, :budget].each do |c|
      config.columns[c].options = quarterly_amount_field_options
      config.columns[c].inplace_edit = true
    end

    [:start, :end].each do |c|
      config.columns[c].label = "#{c.to_s.capitalize} Date"
    end
    %w[q1 q2 q3 q4].each do |quarter|
      c="spend_"+quarter
      c=c.to_sym
      config.columns[c].inplace_edit = true
      config.columns[c].options = quarterly_amount_field_options
      config.columns[c].label = "Expenditure in GOR FY 09-10 "+quarter.capitalize
    end
    # add in later version, not part of minimal viable product
    #config.columns[:indicators].form_ui = :select
    #config.columns[:indicators].options = {:draggable_lists => true}
  end

  def create_from_file
    super @@columns_for_file_upload
  end

  def code
    logger.debug(params[:id]) #can get id of record
    redirect_to manage_code_assignments_url(params[:id])
  end

  def conditions_for_collection
    ["activities.type IS NULL "]
  end

  def active_scaffold_block
    #TODO figure out how to return block for the AS config
    # so I can subclass then yield this block & block
    # that changes things for activity so don't have to
    # have duplicate code w some modifications
  end

end

