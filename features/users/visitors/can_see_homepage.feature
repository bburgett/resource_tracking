Feature: Visitor can see homepage
  In order to be awesome
  As a visitor
  I want to be able to see a landing page

@run
Scenario: See heading and login
  When I go to the home page
  Then I should see the visitors header
  Then I should see the common footer
