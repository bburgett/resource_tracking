class ActivitiesController < ActiveScaffoldController
  authorize_resource

  before_filter :check_user_has_data_response

  include ActivitiesHelper
  @@shown_columns = [:projects, :provider, :description,  :budget  ]
  @@create_columns = [:projects, :locations, :provider, :name, :description,  :start, :end, :beneficiaries, :text_for_beneficiaries,:spend, :spend_q4_prev, :spend_q1, :spend_q2, :spend_q3, :spend_q4, :budget]
  def self.create_columns
    @@create_columns
  end
  @@update_columns = [:projects, :locations, :text_for_provider, :provider, :name, :description,  :start, :end, :beneficiaries, :text_for_beneficiaries, :text_for_targets, :spend, :spend_q4_prev, :spend_q1, :spend_q2, :spend_q3, :spend_q4, :budget]
  @@columns_for_file_upload = %w[name description
    text_for_targets text_for_beneficiaries text_for_provider
    spend spend_q4_prev spend_q1 spend_q2 spend_q3 spend_q4 budget]

  map_fields :create_from_file,
    @@columns_for_file_upload,
    :file_field => :file

  active_scaffold :activity do |config|
    config.columns =  @@shown_columns
    config.create.columns = @@create_columns
    config.update.columns = @@update_columns
    list.sorting = {:name => 'DESC'}

    #TODO better name / standarize on verb noun or just noun
    config.action_links.add('Classify',
      :action => "popup_coding",
      :parameters =>{:controller=>'activities'},
      :type => :member,
      :popup => true,
      :label => "Classify")

    config.nested.add_link("Institutions Assisted", [:organizations])
    config.columns[:organizations].association.reverse = :activities
    config.nested.add_link("Sub Implementers", [:sub_activities])
    # we want to use this below but its frazzed
    # config.columns[:organizations].form_ui = :select # TODO remove and let subform handle it once we fix subforms
    # config.columns[:organizations].label = "Targets"

    config.nested.add_link("Comments", [:comments])
    config.columns[:comments].association.reverse = :commentable
#    config.columns[:projects].inplace_edit        = :ajax#TODO get working
    config.columns[:projects].form_ui             = :select
    config.columns[:locations].form_ui            = :select
    config.columns[:locations].label              = "Districts Worked In"
#    config.columns[:projects].options[:update_column] = [:provider] #TODO fix AS not doing this correctly with multi check boxes
#    config.columns[:provider].inplace_edit        = :ajax#TODO get working
    config.columns[:provider].form_ui             = :select
    config.columns[:provider].association.reverse = :provider_for
    config.columns[:provider].label               = "Implementer"
    config.columns[:name].inplace_edit            = true
    config.columns[:name].label                   = "Name (Optional)"
    config.columns[:description].inplace_edit     = true
    config.columns[:description].options     = {:cols => 60, :rows => 8}
    config.columns[:beneficiaries].form_ui = :select
    [config.update.columns, config.create.columns].each do |columns|
      columns.add_subgroup "Planned Expenditure" do |budget_group|
        budget_group.add :budget
      end
      columns.add_subgroup "Past Expenditure" do |funds_group|
        funds_group.add :spend, :spend_q4_prev, :spend_q1, :spend_q2, :spend_q3, :spend_q4
      end
    end

    config.columns[:spend].label = "Total Spent GOR FY 09-10"
    config.columns[:budget].label = "Total Budget GOR FY 10-11"
    [:spend, :budget].each do |c|
      quarterly_amount_field_options config.columns[c]
      config.columns[c].inplace_edit = true
    end

    [:start, :end].each do |c|
      config.columns[c].label = "#{c.to_s.capitalize} Date"
    end

    %w[q1 q2 q3 q4].each do |quarter|
      c = "spend_"+quarter
      c = c.to_sym
      config.columns[c].inplace_edit = true
      quarterly_amount_field_options config.columns[c]
      config.columns[c].label = "Expenditure in Your FY 09-10 "+quarter.capitalize
    end
    config.columns[:spend_q4_prev].inplace_edit = true
    quarterly_amount_field_options config.columns[:spend_q4_prev]
    config.columns[:spend_q4_prev].label = "Expenditure in your FY 08-09 Q4"
    [:text_for_beneficiaries, :text_for_targets, :text_for_provider].each do |c|
      config.columns[c].form_ui = :textarea
      config.columns[c].options = {:cols => 50, :rows => 3}
    end
    # add in later version, not part of minimal viable product
    #config.columns[:indicators].form_ui = :select
    #config.columns[:indicators].options = {:draggable_lists => true}
  end

  def create_from_file
    super @@columns_for_file_upload
  end

  #AS helper method
  def popup_coding
    redirect_to budget_activity_coding_url(params[:id])
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

  def beginning_of_chain
    super.available_to current_user
  end

  #fixes create
  def before_create_save record
    record.data_response = current_user.current_data_response
  end

  def approve
    true
  end

end
