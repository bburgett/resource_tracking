Feature: In order to reduce costs
  As a reporter
  I want to be able to manage my data response settings

Scenario: Browse to data response edit page
  Given the following organizations 
    | name   |
    | UNDP   |
  Given the following reporters 
     | name         | organization |
     | undp_user    | UNDP         |
  Given a data request with title "Req1" from "UNAIDS"
  Given a data response to "Req1" by "UNDP"
  Given a refactor_me_please current_data_response for user "undp_user"
  Given I am signed in as "undp_user"
  When I follow "My Data"
  And I follow "Configure"
  Then I should be on the data response page for "Req1"
  And I should see "Currency"

@run
Scenario: Edit data response
  Given the following organizations 
    | name   |
    | UNDP   |
  Given the following reporters 
     | name         | organization |
     | undp_user    | UNDP         |
  Given a data request with title "Req1" from "UNAIDS"
  Given a data response to "Req1" by "UNDP"
  Given a refactor_me_please current_data_response for user "undp_user"
  Given I am signed in as "undp_user"
  When I go to the data response page for "Req1"
  And I fill in "data_response_fiscal_year_start_date" with "2010-01-01"
  And I fill in "data_response_fiscal_year_end_date" with "2010-01-02"
  And I press "Save"
  Then I should see "Changes saved successfully"

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