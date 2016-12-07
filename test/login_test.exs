# Login Test
#
# Test Steps:
#  Login with wrong password
#  Login with wrong username
#  Reset password
#  Use old password
#  Use old reset token

Application.start :hound

defmodule SymphonyQA.LoginTest do
  use Hound.Helpers
  use ExUnit.Case

  test "Login Test" do

    Hound.start_session

    navigate_to "http://localhost:4002"
    IO.inspect page_title()
    assert page_title() == "Symphony"

    # Login with wrong password
    Utilities.login("test@example.com","wrong")
    assert page_source =~ "Wrong Password or Email Address"
    assert current_url == "http://localhost:4002/login"

    # Login with wrong user name
    Utilities.login("wrong@example.com","password")
    assert page_source =~ "Wrong Password or Email Address"
    assert current_url == "http://localhost:4002/login"

    # reset password
    Utilities.forget_password("test@example.com")
    Utilities.create_user_password('passw0rd')

    # Login with old password
    Utilities.login("test@example.com","password")
    assert page_source =~ "Wrong Password or Email Address"
    assert current_url == "http://localhost:4002/login"

    Utilities.login("test@example.com","passw0rd")
    Utilities.logout

    # Try to use the reset link again
    #navigate_to "http://localhost:4002/emails"
    Utilities.create_user_password("hack_password", "")


    # Automatically invoked if the session owner process crashes
    Hound.end_session
  end
end
