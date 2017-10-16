require "rails_helper"

feature "Notification" do
  let( :archer ){ create( :archer ) }
  let( :lana ){ create( :lana ) }
  let( :malory ){ create( :malory ) }
  scenario "Someone follows another" do
    act_as( archer ) do
      visit user_path( lana )
      click_button "Follow"
    end

    act_as( malory ) do
      visit user_path( lana )
      click_button "Follow"
    end

    login( lana )

    visit root_path

    expect( page ).to have_content( "#{ archer.name } followed you." )
    expect( page ).to have_content( "#{ malory.name } followed you." )
  end

  scenario "Someone sent a message to another" do
    archer.follow( lana )
    lana.follow( archer )

    act_as( archer ) do
      visit messages_user_path( archer )
      select lana.name, from: "message_receiver_id"
      fill_in "message_content", with: "HELLO"
      click_button "Send"
    end

    login( lana )

    visit messages_user_path( lana )

    visit root_path

    expect( page ).to have_content( "#{ archer.name } sent you a message." )

    visit messages_user_path( lana )
    visit root_path

    expect( page ).not_to have_content( "#{ archer.name } sent you a message." )
  end

  scenario "Someone replied another" do
    act_as( archer ) do
      visit root_path
      fill_in "micropost[content]", with: "@#{ lana.name}\nHELLO"
      click_button "Post"
    end

    login( lana )

    visit root_path
    expect( page ).to have_content( "#{ archer.name } replied to you." )
  end
end
