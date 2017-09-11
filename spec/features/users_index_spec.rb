require "rails_helper"

feature "Users index" do
  shared_context "logged in" do | u |
    let( u ) do
      user = create( u )
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
      user
    end
  end

  context "when logged in" do
    include_context "logged in", :user
    scenario "shows index page including pagination" do
      user

      30.times do | n |
        create( :unspecified )
      end

      visit users_path

      expect( page ).to have_selector "div.pagination"
      User.paginate( page: 1 ).each do | u |
        expect( page ).to have_selector "a[href='#{ user_path( u ) }']", text: u.name
      end
    end
  end

  context "when admin delete a user" do
    include_context "logged in", :michael
    scenario "can delete the user and the user is deleted on the page as well" do
      create( :archer )
      31.times do
        create( :unspecified )
      end

      michael

      users = User.paginate( page: 1 )
      first_user = users.first

      visit users_path

      expect( page ).to have_selector "a[href='#{ user_path( first_user ) }']", text: "delete"

      find( "a[href='#{ user_path( first_user ) }']", text: "delete" ).click

      # failed!!
      # click_link "a[href='#{ user_path( f_user.first ) }']", text: "delete"

      expect( page ).not_to have_selector "a[href='#{ user_path( first_user ) }']"

    end
  end
end
