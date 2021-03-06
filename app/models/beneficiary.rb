# == Schema Information
#
# Table name: codes
#
#  id                  :integer         not null, primary key
#  parent_id           :integer
#  lft                 :integer
#  rgt                 :integer
#  short_display       :string(255)
#  long_display        :string(255)
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#  start_date          :date
#  end_date            :date
#  replacement_code_id :integer
#  type                :string(255)
#  external_id         :string(255)
#

class Beneficiary < Code
  has_and_belongs_to_many :activities # organizations targeted by this activity / aided

end
