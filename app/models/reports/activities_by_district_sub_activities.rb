require 'fastercsv'

class Reports::ActivitiesByDistrictSubActivities

  def initialize
    locations     = Location.find(:all, :select => 'short_display').map(&:short_display).sort
    beneficiaries = Beneficiary.find(:all, :select => 'short_display').map(&:short_display).sort

    @csv_string = FasterCSV.generate do |csv|
      csv << build_header(beneficiaries, locations)

      #print data
      Activity.all.each do |a|
        row = build_row(a, beneficiaries, locations)

        a.sub_activities.each do |sub_act|
          sub_row = row.dup
          sub_row << (sub_act.provider.nil? ? " " : "#{h sub_act.provider.name}" )
          sub_row << [ sub_act.budget, sub_act.budget_percentage, sub_act.spend, sub_act.spend_percentage ]

          #print out a row for each project
          if a.projects.empty?
            sub_row.unshift(" ")
            csv << sub_row.flatten
          else
            a.projects.each do |proj|
              proj_row = sub_row.dup
              proj_row.unshift("#{h proj.name}")
              csv << proj_row.flatten
            end
          end
        end
      end
    end
  end

  def csv
    @csv_string
  end

  protected

  def h(str)
    if str
      str.gsub!(',', '  ')
      str.gsub!("\n", '  ')
      str.gsub!("\t", '  ')
      str.gsub!("\015", "  ") # damn you ^M
    end
    str
  end

  def build_header(beneficiaries, locations)
    #print header
    header = []
    header << [ "project", "org.name", "org.type", "activity.name", "activity.description" ]
    beneficiaries.each do |ben|
      header << "#{ben}"
    end
    header << ["activity.text_for_beneficiaries", "activity.text_for_targets", "activity.target", "activity.budget", "activity.spend", "currency", "activity.start", "activity.end", "activity.provider"]
    locations.each do |loc|
      header << "#{loc}"
    end
    header << [ "sub_activity.provider", "sub_activity.budget", "sub_activity.budget_percentage", "sub_activity.spend", "sub_activity.spend_percentage" ]
    header.flatten
  end

  def build_row(activity, beneficiaries, locations)
    org        = activity.data_response.responding_organization
    act_benefs = activity.beneficiaries.map(&:short_display)
    act_locs   = activity.locations.map(&:short_display)

    row = []
    row << [ "#{h org.name}", "#{org.type}", "#{h activity.name}", "#{h activity.description}" ]
    beneficiaries.each do |ben|
      row << (act_benefs.include?(ben) ? "yes" : " " )
    end
    row << ["#{h activity.text_for_beneficiaries}", "#{h activity.text_for_targets}", "#{activity.target}", "#{activity.budget}", "#{activity.spend}", "#{activity.data_response.currency}", "#{activity.start}", "#{activity.end}" ]
    row << (activity.provider.nil? ? " " : "#{h activity.provider.name}" )
    locations.each do |loc|
      row << (act_locs.include?(loc) ? "yes" : " " )
    end
    row.flatten

  end

end

