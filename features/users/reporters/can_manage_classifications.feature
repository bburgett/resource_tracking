Feature: NGO/donor can see activity breakdowns for each project 
  In order to increase the quality of information reported
  As a NGO/Donor
  I want to be able to break down activities 

@run
Scenario: See list of activities for my project
  Given a project with name "TB Treatment Project"
  Given an activity with name "TB Drugs procurement" in project "TB Treatment Project" 
  Given I am signed in as a reporter
  And I follow "My Data" within "div#main-nav"
  Then show me the page
  And I follow "Classifications" within "div#sub-nav"
  Then show me the page