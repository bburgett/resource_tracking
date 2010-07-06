class ProjectsController < ApplicationController
  @@shown_columns = [:name, :description]
  @@create_columns = [:name, :description, :locations, :spend_q1, :spend_q2, :spend_q3, :spend_q4, :budget_q1, :budget_q2, :budget_q3, :budget_q4]
  def self.create_columns
    @@create_columns
  end
  @@columns_for_file_upload = @@shown_columns.map {|c| c.to_s} # TODO fix bug, locations for instance won't work

  map_fields :create_from_file,
    @@columns_for_file_upload,
    :file_field => :file

  active_scaffold :project do |config|
    config.columns =  @@shown_columns
    list.sorting = {:name => 'DESC'}
    config.nested.add_link("Activities", [:activities])

    config.nested.add_link("Comments", [:comments])
    config.columns[:comments].association.reverse = :commentable

    config.create.columns = @@create_columns
    config.update.columns = config.create.columns
    config.columns[:name].inplace_edit = true
    config.columns[:description].inplace_edit = true
    config.columns[:description].form_ui = :textarea
    
    [:spend_q1, :spend_q2, :spend_q3, :spend_q4].each do |c|
      config.columns[c].inplace_edit = true
      config.columns[c].label = "Calender 2009-2010 "+c.to_s.humanize.sub("q","Q")
    end
    [:budget_q1, :budget_q2, :budget_q3, :budget_q4].each do |c|
      config.columns[c].inplace_edit = true
      config.columns[c].label = "Calender 2010-2011 "+c.to_s.humanize.sub("q","Q")
    end
    config.columns[:locations].form_ui = :select
    config.columns[:locations].label = "Districts Worked In"
  end

  record_select :per_page => 20, :search_on => 'name', :order_by => "name ASC"

  def create_from_file
    super @@columns_for_file_upload
  end

  def to_label
    @s="Project: "
    if name.nil? || name.empty?
      @s+"<No Name>"
    else
      @s+name
    end
  end

  self.set_active_scaffold_column_descriptions
end
