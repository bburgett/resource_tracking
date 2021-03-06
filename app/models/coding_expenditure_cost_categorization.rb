class CodingExpenditureCostCategorization < CodeAssignment

  def self.classified(activity)
    available_codes = available_codes(activity)
    codings_sum(available_codes, activity, activity.spend) == activity.spend
  end

  def self.available_codes(activity = nil)
    CostCategory.roots
  end
end
