require "rails_helper"

feature "Message" do
  context "messages display" do
    scenario "sender viewing" do
      message = create( :message )
      user = User.first
      user2 = User.second

      user.password = "password"

      login( user )

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

      receiver.password = "password"
      login( receiver )

      visit messages_user_path( receiver.id )

      expect( page ).to have_content( "#{ receiver.sending.count.to_s } sending" )
      expect( page ).to have_content( "#{ receiver.receiving.count.to_s } receiving" )
      expect( page ).to have_content( message.content )
      expect( page ).to have_selector( "li[id='message-#{ message.id }']" )
      expect( page ).to have_selector( "a[href='#{ user_path( sender.id ) }']", text: sender.name )
      expect( page ).to have_selector( "a[href='#{ user_path( receiver.id ) }']", text: receiver.name )
    end
  end

  context "message sending" do
    let( :archer ){ create( :archer ) }
    let( :lana ){ create( :lana ) }
    let( :malory ){ create( :malory ) }
    let( :bob ){ create( :bob ) }

    before do
      archer.follow( lana )
      lana.follow( archer )
      archer.follow( malory )
      bob.follow( archer )
    end

    scenario "sending" do
      login( archer )

      visit messages_user_path( archer )

      expect( page ).to have_select( "message[receiver_id]",
                                     options: [ "== choose user ==",
                                                lana.name ] )

      select lana.name, from: "message_receiver_id"
      fill_in "message_content", with: "Hello"
      click_button "Send"

      expect( current_path ).to eq messages_user_path( archer )
      expect( page ).to have_content( "Hello" )
      expect( page ).to have_selector( "li[id='message-1']" )
      expect( page ).to have_selector( "a[href='#{ user_path( archer ) }']" )
      expect( page ).to have_selector( "a[href='#{ user_path( lana ) }']" )
    end
  end
end
