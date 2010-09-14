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
  Given I am signed in as "undp_user"
  Then show me the page
  When I follow "My Data"
  And I follow "Configure"
  Then I should be on the data response page
  And I should see "Currency"
