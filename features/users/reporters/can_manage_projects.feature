Feature: In order to reduce costs
  As a reporter
  I want to be able to manage my projects

Scenario: Browse to project edit page
  Given a basic org + reporter profile, with data response, signed in
  When I follow "My Data"
  And I follow "Projects"
  Then I should be on the projects page for "Req1"
  And I should see "Projects" within "div#main"


@run
Scenario Outline: Edit project dates
  Given a basic org + reporter profile, with data response, signed in
  When I go to the projects page for "Req1"
  And I follow "Create New"
  And I fill in "record_name_" with "Some Project"
  And I fill in "record_start_date_" with "<start_date>"
  And I fill in "record_end_date_" with "<end_date>"
  And I press "Create"
  Then show me the page
  Then I should see "<message>"
  And I should see "<specific_message>"
  
  Examples:
    | start_date | end_date   | message                              | specific_message                      |
    | 2010-01-01 | 2010-01-02 | Created Some Project.                | Successfully created Some Project.    |
    |            | 2010-01-02 | Oops, we couldn't save your changes. | Start date is an invalid date         |
    | 2010-05-05 | 2010-01-02 | Oops, we couldn't save your changes. | Start date must come before End date. |
    | 2010-13-01 | 2010-01-02 | Oops, we couldn't save your changes. | Start date is an invalid date         |
    | 2010-12-41 | 2010-01-02 | Oops, we couldn't save your changes. | Start date is an invalid date         |
    | 2010       | 2010-01-02 | Oops, we couldn't save your changes. | Start date is an invalid date         |
    | 2010-01    | 2010-01-02 | Oops, we couldn't save your changes. | Start date is an invalid date         |


@broken
Scenario: Comments should show on DResponse page (no JS)
  Given a basic org + reporter profile, with data response, signed in
  When I go to the data response page for "Req1"
  Then show me the page
  Then I should see "General Questions / Comments"

@broken
@javascript
@slow
Scenario: Comments should show on DResponse page (with JS)
  Given a basic org + reporter profile, with data response, signed in
  When I go to the data response page for "Req1"
  Then I should see "General Questions / Comments"

@broken
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
