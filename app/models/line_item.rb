class LineItem < ActiveRecord::Base
  acts_as_commentable
  belongs_to :activity
  belongs_to :activity_cost_category
  
  # below should be STI's from codes table, include when done
  # belongs_to :hssp_strategic_objective
  # belongs_to :mtefp

  def to_s
    @s="Cost Breakdown: "
    unless activity_cost_category.nil?
      @s+"<No Category>"
    else
      @s+activity_cost_category.to_s
    end
  end
end
