require "rails_helper"

feature "Notification" do
  scenario "Someone follows another" do
    archer = create( :archer )
    lana = create( :lana )
    malory = create( :malory )

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

    save_and_open_page

    expect( page ).to have_content( "#{ archer.name } followed you." )
    expect( page ).to have_content( "#{ malory.name } followed you." )
  end
end
