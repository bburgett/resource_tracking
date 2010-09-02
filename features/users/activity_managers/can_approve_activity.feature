Feature: Activity Manager can approve a code breakdown for each activity 
  In order to increase the quality of information reported
  As a NGO/Donor Activity Manager
  I want to be able to approve activity splits

Background:
  Given the following organizations 
    | name             |
    | WHO              |
    | UNAIDS           |
  Given the following activity managers 
     | name            | organization |
     | who_manager     | WHO          |
  Given a data request with title "Req1" from "UNAIDS"
  Given a data response to "Req1" by "WHO"
  Given a project with name "TB Treatment Project" and an existing response
  Given an activity with name "TB Drugs procurement" in project "TB Treatment Project" and an existing response
  Given a refactor_me_please current_data_response for user "who_manager"
  Given I am signed in as "who_manager"

Scenario: See a breakdown for an activity
  When I go to the activities page
  And I follow "Classify"
  Then I should see "TB Drugs procurement"
  And I should see "Budget"
  And I should see "Budget Cost Categorization"
  And I should see "Expenditure"
  And I should see "Expenditure Cost Categorization"
  And I should see "Providing Technical Assistance"


# note you cant drive this via the normal 'Classify' popup link in Capybara - it wont follow the new browser window 

@slow
@javascript
Scenario: Approve an Activity
  When I go to the activity classification page for "TB Drugs procurement"
  Then I should see "Activity Classification"
  When I check "approve_activity"
  And I go to the activity classification page for "TB Drugs procurement"
  Then the "approve_activity" checkbox should be checked

Scenario: See approved activities
  When I go to the activities page
  Then I should see "Approved?"

Scenario: See unapproved activities highlighted 
  Log in as Activity Manager 
  Go to Activities 
  see unapproved activities highlighted (e.g. red)

