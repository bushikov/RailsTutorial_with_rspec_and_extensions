require "rails_helper"

feature "Site Layouts" do
  before do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  feature "Title" do
    scenario "Home title is set" do
      visit root_path
      expect( page ).to have_title( "Home | #{ @base_title }" )
    end

    scenario "Help title is set" do
      visit help_path
      expect( page ).to have_title( "Help | #{ @base_title }" )
    end

    scenario "About title is set" do
      visit about_path
      expect( page ).to have_title( "About | #{ @base_title }" )
    end

    scenario "Contact title is set" do
      visit contact_url
      expect( page ).to have_title( "Contact | #{ @base_title }" )
    end

    scenario "Sign up title is set" do
      visit signup_path
      expect( page ).to have_title( "Sign up | #{ @base_title }" )
    end
  end

  feature "layout links" do
    scenario "Home" do
      visit root_path
      expect( page ).to have_link "Home", href: root_path
      expect( page ).to have_link "sample app", href: root_path
      expect( page ).to have_link "Help", href: help_path
      expect( page ).to have_link "About", href: about_path
      expect( page ).to have_link "Contact", href: contact_path
    end

    context "header" do
      shared_context "login as" do
        let( :user ) do
          user = create( :user )
          visit login_path
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Log in"
          user
        end
      end

      context "when not logged in" do
        scenario "can access common pages" do
          visit root_path

          expect( page ).to have_link "Home", href: root_path
          expect( page ).to have_link "Help", href: help_path
          expect( page ).to have_link "Log in", href: login_path
        end        
      end

      context "when logged in" do
        include_context "login as"
        scenario "can access various pages" do
          user

          visit root_path

          expect( page ).to have_link "Home", href: root_path
          expect( page ).to have_link "Help", href: help_path
          expect( page ).to have_link "Users", href: users_path
          expect( page ).to have_link "Profile", href: user_path( user )
          expect( page ).to have_link "Settings", href: edit_user_path( user )
          expect( page ).to have_link "Log out", href: logout_path
        end
      end
    end
  end
end
