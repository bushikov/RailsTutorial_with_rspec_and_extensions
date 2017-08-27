require "rails_helper"

feature "Static Pages" do
  before do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end
  scenario "Home title is set" do
    visit static_pages_home_path
    expect( page ).to have_title( "Home | #{ @base_title }" )
  end

  scenario "Help title is set" do
    visit static_pages_help_url
    expect( page ).to have_title( "Help | #{ @base_title }" )
  end

  scenario "About title is set" do
    visit static_pages_about_path
    expect( page ).to have_title( "About | #{ @base_title }" )
  end

  scenario "Contact title is set" do
    visit static_pages_contact_path
    expect( page ).to have_title( "Contact | #{ @base_title }" )
  end
end
