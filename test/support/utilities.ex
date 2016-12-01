defmodule Utilities do
  use Hound.Helpers
  use ExUnit.CaseTemplate

  def login(login,password) do
    navigate_to "http://localhost:4002/login"
    session_email = find_element(:id,"session_email")
    fill_field(session_email,login)
    session_password = find_element(:id,"session_password")
    fill_field(session_password,password)
    click({:css,".form-row:nth-last-child(2)"})
  end

  def logout do
    click({:link_text, "Log Out"})
  end

  def new_portfolio(portfolio) do
    click({:class,"nav-button"})
    # Enter new portfolio and hit create
    portfolio_name = find_element(:id, "portfolio_name")
    fill_field(portfolio_name,portfolio)
    click({:css,".form-row:last-child"})
  end

  def invite_new_admin(admin_email) do
    click({:class,"nav-button"})
    new_admin = find_element(:id, "user_email")
    fill_field(new_admin,admin_email)
    click({:css,".form-row:last-child"})
  end

  def confirm_user_email do
    #Grab dev email and click on password reset link
    in_browser_session "reset password", fn ->
      navigate_to "http://localhost:4002/emails"

      password_reset = find_element(:class,"email-preview-bodies-container")

      line = visible_text(password_reset)

      {index1,_} = :binary.match line , "http"
      {index2,_} = :binary.match line , " to accept"
      link = String.slice(line,index1..index2)

      # set new password and logout
      navigate_to link
      password = find_element(:id,"user_password")
      fill_field(password,"password")

      password_conf = find_element(:id,"user_password_confirmation")
      fill_field(password_conf,"password")

      click({:css,".form-row:last-child"})
      logout
      close_current_window()
    end
  end

  def find_node(node_name) do
    element_list = find_all_elements(:css,"text.nodeText")
    Enum.find(element_list, nil, &(visible_text(&1) == node_name))
  end

  def add_feeder_node(node_name) do
    click({:id,"add-node"})
    element = find_element(:id, "feeder_node_name")
    fill_field(element, node_name)
    click({:css,".form-row:last-child"})
    :timer.sleep(:timer.seconds(1))
  end

  def add_zone(zone_name) do
    click({:id,"add-zone"})
    element = find_element(:id, "zone_name")
    fill_field(element, zone_name)
    click({:css,".form-row:last-child"})
    :timer.sleep(:timer.seconds(1))
  end

  def add_meter(meter_name, interval) do
    click({:id,"add-meter"})
    element = find_element(:id, "meter_name")
    fill_field(element, meter_name)
    element = find_element(:id, "meter_interval_in_secs")
    fill_field(element, interval)
    click({:css,".form-row:last-child"})
    :timer.sleep(:timer.seconds(1))
  end

  def add_battery(brand, model_no, storage_kwh, power_w, cost, install_cost) do
    click({:id,"add-battery"})
    element = find_element(:id, "battery_brand")
    fill_field(element, brand)
    element = find_element(:id, "battery_model_number")
    fill_field(element, model_no)
    element = find_element(:id, "battery_storage_in_watt_hours")
    fill_field(element, storage_kwh)
    element = find_element(:id, "battery_power_in_watts")
    fill_field(element, power_w)
    element = find_element(:id, "battery_cost_in_dollars")
    fill_field(element, cost)
    element = find_element(:id, "battery_install_cost_in_dollars")
    fill_field(element, install_cost)
    click({:css,".form-row:last-child"})
    :timer.sleep(:timer.seconds(1))
  end

  def add_asset(asset_name,size_in_watts, storage_in_watthours, min_on_s, max_on_s, min_off_s, max_off_s) do
    click({:id,"add-asset"})
    take_screenshot("test.png")
    element = find_element(:id, "asset_name")
    fill_field(element, asset_name)
    element = find_element(:id, "asset_rated_size_in_watts")
    fill_field(element, size_in_watts)
    element = find_element(:id, "asset_rated_storage_in_watt_hours")
    fill_field(element, storage_in_watthours)
    element = find_element(:id, "asset_minimum_on_duration_in_secs")
    fill_field(element, min_on_s)
    element = find_element(:id, "asset_maximum_on_duration_in_secs")
    fill_field(element, max_on_s)
    element = find_element(:id, "asset_minimum_off_duration_in_secs")
    fill_field(element, min_off_s)
    element = find_element(:id, "asset_maximum_off_duration_in_secs")
    fill_field(element, max_off_s)
    click({:css,".form-row:last-child"})
    :timer.sleep(:timer.seconds(1))
  end

end
