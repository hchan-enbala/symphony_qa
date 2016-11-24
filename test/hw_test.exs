# Sample test case using hound

Application.start :hound

defmodule SetupNetworkTest do
  use Hound.Helpers
  use ExUnit.Case

  #import Utilities

  #setup_all do

  #end

  test "setup network" do

    Hound.start_session

    navigate_to "http://localhost:4002"
    IO.inspect page_title()
    assert page_title() == "Symphony"

    # Login
    Utilities.login("admin@enbala.com","password")
    assert current_url == "http://localhost:4002/admin/portfolios"
    assert element_displayed?({:class, "no-cards"})

    # Create new portfolio
    Utilities.new_portfolio("First Portfolio")

    #Goes back to the portfolio page
    assert page_source =~ "First Portfolio"
    assert page_source =~ "Invite an Admin"
    assert page_source =~ "This portfolio has no admins"

    # Invite new admin
    Utilities.invite_new_admin("test@example.com")

    assert current_url == "http://localhost:4002/admin/portfolios/1"
    assert page_source =~ "First Portfolio"
    assert page_source =~ "test@example.com"
    assert page_source =~ "A confirmation email has been sent to test@example.com"

    Utilities.confirm_user_email()

    # log out
    Utilities.logout
    assert current_url == "http://localhost:4002/login"

    # login as new user
    navigate_to "http://localhost:4002/login"
    Utilities.login("test@example.com","password")
    assert page_source =~ "First Portfolio"

    # find the root node in the graph
    element = Utilities.find_node("First Portfolio")
    click(element)

    # add a various nodes to the graph to the graph
    assert page_source =~ "Add Node"
    Utilities.add_feeder_node("node1")
    assert page_source =~ "Node Created"

    element = Utilities.find_node("node1")
    click(element)
    Utilities.add_feeder_node("node2")
    assert page_source =~ "Node Created"

    element = Utilities.find_node("node1")
    click(element)
    assert page_source =~ "Add Zone"
    Utilities.add_zone("zone1")
    assert page_source =~ "Zone Created"

    element = Utilities.find_node("zone1")
    click(element)
    assert page_source =~ "Add Zone"
    assert page_source =~ "Add Meter"
    assert page_source =~ "Add Battery"
    assert page_source =~ "Add Asset"

    Utilities.add_meter("meter1","5")
    assert page_source =~ "Meter Created"

    element = Utilities.find_node("zone1")
    click(element)
    Utilities.add_battery("battery1","model1","1200","2000","55000","10000")
    assert page_source =~ "Battery Created"

    element = Utilities.find_node("zone1")
    click(element)
    Utilities.add_asset("asset1", "300000000", "500000", "900","7200", "300", "0")
    assert page_source =~ "Asset Created"

    Utilities.logout

    # Automatically invoked if the session owner process crashes
    Hound.end_session
  end
end
