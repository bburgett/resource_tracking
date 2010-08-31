Feature: Reporter can login
  In order to protect information
  As a reporter
  I want to be able to login

Scenario: Login via home page
  When I go to the home page
  And I follow "Sign in"
  Then I should be on the login page

Scenario: See login form
  When I go to the login page
  Then I should see the visitors header
  Then I should see "Sign in" within "body#login"
  And I should see "Username or Email" within "body#login"
  And I should see "Password" within "body#login"
  Then I should see the common footer

@wip
Scenario: Login with invalid data - see flash message not AR errors
  Given a reporter "Frank" with email "frank@f.com" and password "password"
  When I go to the login page
  And I fill in "Username or Email" with "not a real user"
  And I fill in "Password" with ""
  And I press "Sign in"
  Then I should see "Wrong Username/email and password combination"
  And I should not see "There were problems with the following fields:"

@run
Scenario: Login as a reporter with a username
  Given a reporter "Frank" with email "frank@f.com" and password "password"
  When I go to the login page
  When I fill in "Username or Email" with "Frank"
  And I fill in "Password" with "password"
  Then debug
  And I press "Sign in"
  And I should see the reporters admin nav
  And I should see the main nav tabs

@wip
Scenario: Login as a reporter with email address
  Given a reporter "Frank" with email "frank@f.com" and password "password"
  When I go to the login page
  When I fill in "Username or email" with "frank@f.com"
  And I fill in "Password" with "password"
  And I press "Sign in"
  #Then show me the page
  Then I should be on the reporter dashboard page
  And I should see "Welcome Frank"

@allow-rescue
Scenario Outline: Visit protected page, get redirected to login screen
  When I go to the <page> page
  Then I should see "You must be signed in to do that"
  And I should be on the login page 
  Examples:
    | page            |
    | projects        |
    | funding sources |
    | providers       |
    | activities      |
    | other costs     |

#Active-Scaffold-specific routes
#Scenario Outline: Request protected action, get redirected to login screen
