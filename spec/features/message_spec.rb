require "rails_helper"

feature "Message" do
  context "messages display" do
    scenario "sender viewing" do
      message = create( :message )
      user = User.first
      user2 = User.second

      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "password"
      click_button "Log in"

      visit messages_user_path( user.id )

      expect( page ).to have_content( "#{ user.sending.count.to_s } sending" )
      expect( page ).to have_content( "#{ user.receiving.count.to_s } receiving" )
      expect( page ).to have_content( message.content )
      expect( page ).to have_selector( "li[id='message-#{ message.id }']" )
      expect( page ).to have_selector( "a[href='#{ user_path( user.id ) }']", text: user.name )
      expect( page ).to have_selector( "a[href='#{ user_path( user2.id ) }']", text: user2.name )
    end

    scenario "receiver viewing" do
      message = create( :message )
      sender = User.first
      receiver = User.second

      visit login_path
      fill_in "Email", with: receiver.email
      fill_in "Password", with: "password"
      click_button "Log in"

      visit messages_user_path( receiver.id )

      expect( page ).to have_content( "#{ receiver.sending.count.to_s } sending" )
      expect( page ).to have_content( "#{ receiver.receiving.count.to_s } receiving" )
      expect( page ).to have_content( message.content )
      expect( page ).to have_selector( "li[id='message-#{ message.id }']" )
      expect( page ).to have_selector( "a[href='#{ user_path( sender.id ) }']", text: sender.name )
      expect( page ).to have_selector( "a[href='#{ user_path( receiver.id ) }']", text: receiver.name )
    end
  end
end
