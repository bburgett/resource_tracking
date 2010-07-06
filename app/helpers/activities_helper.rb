module ActivitiesHelper
  def options_for_association_conditions(association)
    vals=[]
    if association.name == :nsp
      if @record.mtef
        ["id in (?)", mtef.valid_children_of_next_type.collect {|c| c.id} ]
      else
        ["1=0"]
      end
    elsif association.name == :nha
        vals = @record.mtef.valid_children_of_next_type.collect {|c| c.id} if @record.mtef
        ["id in (?)",  vals]
    else
        super
    end
  end
end
