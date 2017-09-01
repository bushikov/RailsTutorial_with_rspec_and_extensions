require "rails_helper"

feature "Users Signup" do
  scenario "with invalid signup information" do
    visit signup_path
    expect{
      fill_in "Name", with: ""
      fill_in "Email", with: "user@invalid"
      fill_in "Password", with: "foo"
      fill_in "Confirmation", with: "bar"
      click_button "Create my account"
    }.not_to change( User, :count )
  end

  scenario "with blank name" do
    visit signup_path

    fill_in "Name", with: ""
    fill_in "Email", with: "sample@sample.com"
    fill_in "Password", with: "foobar"
    fill_in "Confirmation", with: "foobar"
    click_button "Create my account"

    expect( page ).to have_content "Name can't be blank"
  end

  scenario "with too long name" do
    visit signup_path
    
    fill_in "Name", with: "a" * 51
    fill_in "Email", with: "sample@sample.com"
    fill_in "Password", with: "foobar"
    fill_in "Confirmation", with: "foobar"
    click_button "Create my account"
    
    expect( page ).to have_content "Name is too long (maximum is 50 characters)"
  end

  scenario "with blank password" do
    visit signup_path

    fill_in "Name", with: "abcedf"
    fill_in "Email", with: ""
    fill_in "Password", with: "foobar"
    fill_in "Confirmation", with: "foobar"
    click_button "Create my account"

    expect( page ).to have_content "Email can't be blank"
  end

  scenario "with too long password" do
    visit signup_path

    fill_in "Name", with: "abcedf"
    fill_in "Email", with: "a" * 255 + "@abc.com"
    fill_in "Password", with: "foobar"
    fill_in "Confirmation", with: "foobar"
    click_button "Create my account"

    expect( page ).to have_content "Email is too long (maximum is 255 characters)"
  end

  scenario "with wrong formatted password" do
    visit signup_path

    fill_in "Name", with: "abcedf"
    fill_in "Email", with: "abc"
    fill_in "Password", with: "foobar"
    fill_in "Confirmation", with: "foobar"
    click_button "Create my account"

    expect( page ).to have_content "Email is invalid"
  end

  scenario "with blank password" do
    visit signup_path

    fill_in "Name", with: "abcedf"
    fill_in "Email", with: "abc@abc.com"
    fill_in "Password", with: ""
    fill_in "Confirmation", with: "foobar"
    click_button "Create my account"

    expect( page ).to have_content "Password can't be blank"
  end

  scenario "with too short password" do
    visit signup_path

    fill_in "Name", with: "abcedf"
    fill_in "Email", with: "abc@abc.com"
    fill_in "Password", with: "foo"
    fill_in "Confirmation", with: "foobar"
    click_button "Create my account"

    expect( page ).to have_content "Password is too short (minimum is 6 characters)"    
  end

  scenario "with valid input" do
    visit signup_path

    expect( page ).to have_selector "form[action='/signup']"
  end

  scenario "valid signup information" do
    visit signup_path

    expect{
      fill_in "Name", with: "abcdef"
      fill_in "Email", with: "abc@abc.com"
      fill_in "Password", with: "foobar"
      fill_in "Confirmation", with: "foobar"
      click_button "Create my account"
    }.to change( User, :count ).by( 1 )

    expect( current_path ).to eq user_path( 1 )

    expect( page ).to have_selector "div[class='alert alert-success']", text: "Welcome to the Sample App!"
  end
end
