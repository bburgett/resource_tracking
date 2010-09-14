Feature: In order to reduce costs
  As a reporter
  I want to be able to manage my data response settings

@run
Scenario: Browse to data response edit page
  Given a basic org + reporter profile, with data response, signed in
  When I follow "My Data"
  And I follow "Configure"
  Then I should be on the data response page for "Req1"
  And I should see "Currency"

@run
Scenario: Edit data response
  Given a basic org + reporter profile, with data response, signed in
  When I go to the data response page for "Req1"
  And I fill in "data_response_fiscal_year_start_date" with "2010-01-01"
  And I fill in "data_response_fiscal_year_end_date" with "2010-01-02"
  And I press "Save"
  Then I should see "Successfully updated."
  
@run
Scenario: Edit data response, invalid dates
  Given a basic org + reporter profile, with data response, signed in
  When I go to the data response page for "Req1"
  And I fill in "data_response_fiscal_year_start_date" with ""
  And I fill in "data_response_fiscal_year_end_date" with ""
  And I press "Save"
  Then I should see "Oops, we couldn't save your changes."


Scenario: Bug: user is logged out if no 'current' data request was set.
  Given the following organizations 
    | name   |
    | UNDP   |
  Given the following reporters 
     | name         | organization |
     | undp_user    | UNDP         |
  Given a data request with title "Req1" from "UNAIDS"
  Given a data response to "Req1" by "UNDP"
  Given I am signed in as "undp_user"
  When I follow "My Data"
  Then I should see "Please select a data request to respond to first"