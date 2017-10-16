require "rails_helper"

feature "Notification" do
  let( :archer ){ create( :archer ) }
  let( :lana ){ create( :lana ) }
  let( :malory ){ create( :malory ) }
  scenario "Someone follows another" do
    visit login_path
    fill_in "Email", with: archer.email
    fill_in "Password", with: archer.password
    click_button "Log in"

    visit user_path( lana )
    click_button "Follow"

    click_link "Log out"

    visit login_path
    fill_in "Email", with: malory.email
    fill_in "Password", with: malory.password
    click_button "Log in"

    visit user_path( lana )
    click_button "Follow"

    click_link "Log out"

    visit login_path
    fill_in "Email", with: lana.email
    fill_in "Password", with: lana.password
    click_button "Log in"

    visit root_path

    expect( page ).to have_content( "#{ archer.name } followed you." )
    expect( page ).to have_content( "#{ malory.name } followed you." )
  end

  scenario "Someone sent a message to another" do
    archer.follow( lana )
    lana.follow( archer )

    visit login_path
    fill_in "Email", with: archer.email
    fill_in "Password", with: archer.password
    click_button "Log in"

    visit messages_user_path( archer )
    select lana.name, from: "message_receiver_id"
    fill_in "message_content", with: "HELLO"
    click_button "Send"

    click_link "Log out"

    visit login_path
    fill_in "Email", with: lana.email
    fill_in "Password", with: lana.password
    click_button "Log in"

    visit messages_user_path( lana )

    visit root_path

    expect( page ).to have_content( "#{ archer.name } sent you a message." )

    visit messages_user_path( lana )
    visit root_path

    expect( page ).not_to have_content( "#{ archer.name } sent you a message." )
  end
end
