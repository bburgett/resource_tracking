require File.dirname(__FILE__) + '/../spec_helper'

describe DataResponse do

    describe "validations" do
      it { should validate_presence_of(:fiscal_year_start_date) }
      it { should validate_presence_of(:fiscal_year_end_date) }
    end
end
