require 'fastercsv'

FasterCSV.open("file.csv", "w" ) do |csv|
  a=Activity.first
  csv << Project.first.attributes.keys + a.attributes.keys + a.attributes.keys
  Activity.all.each do |a|
    if a.sub_activities.empty?
      a.sub_activities.each do |s|
        #csv << a.projects.first.attributes.values + a.attributes.values + s.attributes.values
         puts a.projects.first.attributes.values + a.attributes.values + s.attributes.values
      end
    else
      #csv << a.projects.first.attributes.values + a.attributes.values
      puts a.projects.first.attributes.values + a.attributes.values
    end
  end
end

