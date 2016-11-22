# Sample test case using hound

Application.start :hound


defmodule SetupNetworkTest do
  use Hound.Helpers
  use ExUnit.Case

  def find_node(node_name) do
    element_list = find_all_elements(:css,"text.nodeText")
    Enum.find(element_list, nil, &(visible_text(&1) == node_name))
  end

  def run do
    Hound.start_session

    navigate_to "http://localhost:4002/login"

    sign_in_form = find_element(:class, "login-wrapper")

    # Sign in as admin
    sign_in_form
    |> find_within_element(:id, "session_email")
    |> fill_field("test@example.com")

    sign_in_form
    |> find_within_element(:id, "session_password")
    |> fill_field("password")

    sign_in_form
    |> find_within_element(:css, "button")
    |> click

    #element = find_node("First Portfolio")
    #element = find_element(:css,"text.nodeText")
    #IO.inspect(visible_text(element))
    element = find_node("First Portfolio")
    click(element)

    assert page_source =~ "Add Node"
    click({:id,"add-node"})

    element = find_element(:id, "feeder_node_name")
    fill_field(element, "node1")
    click({:css,".form-row:last-child"})


    #click({:link_text, "Log Out"})

    #password_reset = find_element(:class,"email-preview-bodies-container")

    #IO.inspect(visible_text(password_reset))

    #password_reset
    #|> find_within_element(:css, "a[href]",1)
    #|> click
    #element = find_element(:id,"session_email")
    #fill_field(element,"admin@enbala.com")
    #click({:css,".form-row:last-child"})


  #  line = visible_text(password_reset)

  #  {index1,_} = :binary.match line , "http"
  #  {index2,_} = :binary.match line , " to accept"
  #  link = String.slice(line,index1..index2)

    #navigate_to link

  #  navigate_to(link)

    #password_reset
    #|> find_within_element(:class,"email-preview-body")
    #|> find_within_element(:tag,"body")
    #|> find_within_element(:link_text,"hello",1)
    #|> click

    #password = find_element(:id,"user_password")
    #fill_field(password,"password")

    #password_conf = find_element(:id,"user_password_confirmation")
    #fill_field(password_conf,"password")

    #click({:css,".form-row:last-child"})


    # Automatically invoked if the session owner process crashes
    Hound.end_session

  end
  test "setup network" do
    run
  end
end
