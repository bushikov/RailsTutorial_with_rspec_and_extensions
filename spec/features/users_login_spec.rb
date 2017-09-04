require "rails_helper"

feature "Users Login" do
  feature "login with invalid information" do
    scenario "there is flash message only in login page" do
      visit login_path
      
      fill_in "Email", with: ""
      fill_in "Password", with: ""
      click_button "Log in"

      expect( current_path ).to eq login_path

      expect( page ).to have_selector "div[class='alert alert-danger']", text: "Invalid email/password combination"

      visit root_path
      expect( page ).not_to have_selector "div[class='alert alert-danger']", text: "Invalid email/password combination"
    end
  end

  feature "login with valid information followed by logout" do
    before do
      @user = create( :user )
    end

    scenario "the correct page is rendered" do
      visit login_path

      fill_in "Email", with: @user.email
      fill_in "Password", with: "password"
      click_button "Log in"

      expect( page ).not_to have_selector "a[href='#{ login_path }']"
      expect( page ).to have_selector "a[href='#{ logout_path }']"
      expect( page ).to have_selector "a[href='#{ user_path( @user ) }']"

      # click_link "Account"
      click_link "Log out"
      
      expect( page ).to have_selector "a[href='#{ login_path }']"
      expect( page ).not_to have_selector "a[href='#{ logout_path }']"
      expect( page ).not_to have_selector "a[href='#{ user_path( @user ) }']"
    end
  end
end
