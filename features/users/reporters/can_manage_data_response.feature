Feature: In order to reduce costs
  As a reporter
  I want to be able to manage my data response settings

Scenario: Browse to data response edit page
  Given a basic org + reporter profile, with data response, signed in
  When I follow "My Data"
  And I follow "Configure"
  Then I should be on the data response page for "Req1"
  And I should see "Currency"

Scenario: Edit data response
  Given a basic org + reporter profile, with data response, signed in
  When I go to the data response page for "Req1"
  And I fill in "data_response_fiscal_year_start_date" with "2010-01-01"
  And I fill in "data_response_fiscal_year_end_date" with "2010-01-02"
  And I press "Save"
  Then I should see "Successfully updated."
  
Scenario: Edit data response, invalid dates
  Given a basic org + reporter profile, with data response, signed in
  When I go to the data response page for "Req1"
  And I fill in "data_response_fiscal_year_start_date" with ""
  And I fill in "data_response_fiscal_year_end_date" with ""
  And I press "Save"
  Then show me the page
  Then I should see "Oops, we couldn't save your changes."

@run
Scenario: Comments should show on DResponse page (no JS)
  Given a basic org + reporter profile, with data response, signed in
  When I go to the data response page for "Req1"
  Then I should see "General Questions / Comments"

@run
@javascript
@slow
Scenario: Comments should show on DResponse page (with JS)
  Given a basic org + reporter profile, with data response, signed in
  When I go to the data response page for "Req1"
  Then I should see "General Questions / Comments"

Scenario: BUG: 5165708 - AS Comments breaking when validation errors on DResponse form
  Given a basic org + reporter profile, with data response, signed in
  When I go to the data response page for "Req1"
  And I fill in "data_response_fiscal_year_start_date" with ""
  And I fill in "data_response_fiscal_year_end_date" with ""
  And I press "Save"
  Then I should not see "Something went wrong, if this happens repeatedly, contact an administrator."

@javascript
@slow
Scenario: BUG: 5165708 - AS Comments breaking when validation errors on DResponse form
  Given a basic org + reporter profile, with data response, signed in
  When I go to the data response page for "Req1"
  And I fill in "data_response_fiscal_year_start_date" with ""
  And I fill in "data_response_fiscal_year_end_date" with ""
  And I press "Save"
  Then I should not see "Something went wrong, if this happens repeatedly, contact an administrator."
  And I should not see "ActionController::InvalidAuthenticityToken"

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