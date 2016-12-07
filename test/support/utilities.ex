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
    :timer.sleep(:timer.seconds(3))
  end

  def logout do
    click({:link_text, "Log Out"})
  end

  def home_button do
    header = find_element(:id, "header")
    home = find_within_element(header, :class, "left")
    click(home)
    :timer.sleep(:timer.seconds(3))
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

  def create_user_password(password) do
    #Grab dev email and click on password reset link
    in_browser_session "reset password", fn ->
      navigate_to "http://localhost:4002/emails"

      password_reset = find_element(:class,"email-preview-bodies-container")

      line = visible_text(password_reset)

      # hack to parse the reset link - not sure how to do this better
      {index1,_} = :binary.match line , "http"
      line = String.slice(line,index1..-1)
      {index2,_} = :binary.match line , " to "
      link = String.slice(line,0..index2)

      # set new password and logout
      navigate_to link
      password_field = find_element(:id,"user_password")
      fill_field(password_field,password)

      password_conf = find_element(:id,"user_password_confirmation")
      fill_field(password_conf,password)

      click({:css,".form-row:last-child"})
      logout
      change_to_default_session()
    end
  end

  def create_user_password(password, _) do
    #Grab dev email and click on password reset link
    in_browser_session "reset password", fn ->

      navigate_to "http://localhost:4002/emails"

      password_reset = find_element(:class,"email-preview-bodies-container")

      line = visible_text(password_reset)

      # hack to parse the reset link - not sure how to do this better
      {index1,_} = :binary.match line , "http"
      line = String.slice(line,index1..-1)
      {index2,_} = :binary.match line , " to "
      link = String.slice(line,0..index2)

      # set new password and logout
      navigate_to link
      :timer.sleep(:timer.seconds(2))
      take_screenshot("/home/enbala/symphony_qa/test1.png")
      assert page_source =~ "Invalid token"
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

  def forget_password(email) do
    # click forget password on login screen
    click({:css,".form-row:last-child"})
    # Fill in user email in forget password dialog, click submit
    element = find_element(:id, "user_email")
    fill_field(element, email)
    click({:css,".form-row:last-child"})
  end

  def invite_user_dialog(email_list) do
    # list of user:password tuples
    :timer.sleep(:timer.seconds(1))
    click({:id,"show-item"})
    Enum.each(email_list, &(invite_user(&1)))
  end

  def invite_user(email_password) do
    {email,password} = email_password
    click({:link_text, "Invite User"})
    element = find_element(:id, "user_email")
    fill_field(element, email)
    click({:css,".form-row:last-child"})
    :timer.sleep(:timer.seconds(2))
    create_user_password(password)
  end

  def promote_user(email) do
    click({:id,"show-item"})
    click({:link_text, email})
    click({:class, "warning-button"})
    :timer.sleep(:timer.seconds(2))
    accept_dialog
  end

  def demote_user(email) do
    click({:id,"show-item"})
    click({:link_text, email})
    click({:class, "warning-button"})
    :timer.sleep(:timer.seconds(2))
    accept_dialog
  end

end
