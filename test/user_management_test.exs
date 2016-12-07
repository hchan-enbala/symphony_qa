# User Management Test
#
# Test Steps:
#   Create portfolio and one admin
#   Create two more users
#   Promote one user, demote the original admin
#   Verify that non-admins can not administer users

Application.start :hound

defmodule SymphonyQA.UserManagementTest do
  use Hound.Helpers
  use ExUnit.Case

  test "UserManagementTest" do

    Hound.start_session

    navigate_to "http://localhost:4002"
    IO.inspect page_title()
    assert page_title() == "Symphony"

    # Login
    Utilities.login("admin@enbala.com","password")
    assert current_url == "http://localhost:4002/admin/portfolios"

    # Create new portfolio
    Utilities.new_portfolio("UserManagement Portfolio")

    # Goes back to the portfolio page
    assert page_source =~ "UserManagement Portfolio"
    assert page_source =~ "Invite an Admin"
    assert page_source =~ "This portfolio has no admins"

    # Invite new admin
    Utilities.invite_new_admin("user1@example.com")

    assert page_source =~ "UserManagement Portfolio"
    assert page_source =~ "user1@example.com"
    assert page_source =~ "A confirmation email has been sent to user1@example.com"

    Utilities.create_user_password("password")
    Utilities.logout
    assert current_url == "http://localhost:4002/login"

    # login as user1
    Utilities.login("user1@example.com","password")

    # create user2 and user3
    element = Utilities.find_node("UserManagement Portfolio")
    click(element)

    Utilities.invite_user_dialog([{"user2@example.com","password"},{"user3@example.com","password"}])
    Utilities.home_button


    # promote user2 but leave user3 as is
    element = Utilities.find_node("UserManagement Portfolio")
    click(element)
    Utilities.promote_user("user2@example.com")
    assert page_source =~ "This user has been made an admin."
    Utilities.logout

    # login as user3 and try do stuff in user management
    Utilities.login("user3@example.com","password")
    element = Utilities.find_node("UserManagement Portfolio")
    click(element)
    click({:id,"show-item"})
    refute page_source =~ "Invite User"
    refute page_source =~ "Users"
    Utilities.logout

    # login as user2 and demote user1
    Utilities.login("user2@example.com","password")
    element = Utilities.find_node("UserManagement Portfolio")
    click(element)
    Utilities.demote_user("user1@example.com")
    assert page_source =~ "This user has been demoted."
    Utilities.logout

    # login as user1 and try to do stuff in user management
    Utilities.login("user1@example.com","password")
    element = Utilities.find_node("UserManagement Portfolio")
    click(element)
    click({:id,"show-item"})
    refute page_source =~ "Invite User"
    refute page_source =~ "Users"
    Utilities.logout

    # Automatically invoked if the session owner process crashes
    Hound.end_session
  end
end
