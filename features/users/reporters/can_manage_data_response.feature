Feature: In order to reduce costs
  As a reporter
  I want to be able to manage my data response settings

@run
Scenario: Creates an implementer funding flow
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