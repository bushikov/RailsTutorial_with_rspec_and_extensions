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
  end
end
