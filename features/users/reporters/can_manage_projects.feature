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
  Then I should see "<message>"
  And I should see "<specific_message>"
  
  Examples:
    | start_date | end_date   | message                              | specific_message                      |
    | 2010-01-01 | 2010-01-02 | Created Some Project                 | Created Some Project                  |
    |            | 2010-01-02 | Oops, we couldn't save your changes. | Start date is an invalid date         |
    | 2010-05-05 | 2010-01-02 | Oops, we couldn't save your changes. | Start date must come before End date. |
    | 2010-13-01 | 2010-01-02 | Oops, we couldn't save your changes. | Start date is an invalid date         |
    | 2010-12-41 | 2010-01-02 | Oops, we couldn't save your changes. | Start date is an invalid date         |
    | 2010       | 2010-01-02 | Oops, we couldn't save your changes. | Start date is an invalid date         |
    | 2010-01    | 2010-01-02 | Oops, we couldn't save your changes. | Start date is an invalid date         |

