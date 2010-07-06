# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

require 'yaml'
require 'fastercsv'

model_helps = open ('db/seed_files/model_help.yaml') { |f| YAML.load(f) }
def seed_model_help_from_yaml doc
  doc.each do |h|
    model_help_attribs = h.last
    #TODO replace line below, may cause trouble during deployment
    #     can replace after add rescue below
    #`touch db/seed_files/#{model_help_attribs["model_name"]}_help.yaml`
    seed_model_and_field_help model_help_attribs
  end
end

def seed_model_and_field_help  attribs 
  model_help=ModelHelp.find_or_create_by_model_name attribs["model_name"]
  model_help.update_attributes attribs
  seed_field_help_from_yaml model_help
end

def seed_field_help_from_yaml model_help
  field_helps = open ("db/seed_files/#{model_help.model_name}_help.yaml") { |f| YAML.load(f) }
  if field_helps
    field_help_attribs = field_helps.map { |h| h.last }
    field_help_attribs.each do |a|
      fh = model_help.field_help.find_or_create_by_attribute_name a["attribute_name"]
      fh.update_attributes a
    end #TODO add rescue if fields file is not there
  end
end

seed_model_help_from_yaml model_helps

#TODO seed code values
#
Code.delete_all
FasterCSV.foreach("db/seed_files/codes.csv", :headers=>true) do |row|
  c=nil #Code.first( :conditions => {:id =>row[:id]}) implement update later
  if c.nil?
    c=Code.new 
    c.id=row["id"]
  end
  #puts row.inspect
  %w[parent_id type short_display long_display].each do |field|
    #puts "#{field}: #{row[field]}"
    c.send "#{field}=", row[field]
  end
  unless c.short_display
    c.short_display=row["class"]
  end
  if c.type=="NhaNasa"
    c.type="Nha"
  end
  #puts c.inspect
  puts "error on #{row}" unless c.save
  #puts c.inspect
end

Code.all.each do |code|
  other_type_children=code.children.collect {|c| c.class!=code.class}
  code.valid_children_of_next_type = other_type_children
  code.save
  #todo add links to those of children so code to
  #get the children when a super code is selected
  #is easier / works at all
end

end
%w[ Muhanga Rusizi Musanze Rubavu].each do |district|
  Location.find_or_create_by_short_display district
end

donors=%w[ USAID WHO CDC GTZ] +["Global Fund", "World Bank"]
donors.each do |donor|
  Donor.find_or_create_by_name donor
end

%w[ self ].each do |ngo|
  Ngo.find_or_create_by_name ngo
end
