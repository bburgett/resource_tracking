puts "\n  Loading cost_categories.csv..."
CostCategory.delete_all
FasterCSV.foreach("db/seed_files/cost_categories.csv", :headers=>true) do |row|

  c             = CostCategory.new
  c.external_id = row["id"]
  p             = CostCategory.find_by_external_id(row["parent_id"])
  c.parent_id   = p.id unless p.nil?
  c.description = row["description"]

  c.short_display=row["short_display"]

  print "."
  puts "error on #{row}" unless c.save!
  #puts "  #{c.id}"
end