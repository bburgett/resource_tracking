module FundingFlowsHelper
  def options_for_association_conditions(association)
    if association.name == :from
        ["type in (?) and name != ?", "Donor", "self" ]
    elsif association.name == :to
        ["type in (?) and name != ?",  "Ngo", "self"]
    else
        super
    end
  end
end
