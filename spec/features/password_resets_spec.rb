require "rails_helper"

feature "Password resets" do
  let( :archer ){ create( :archer ) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  context "given invalid email address on new page" do
    scenario "mail will not be sent and a message will be present on new page" do
      visit new_password_reset_path

      expect{
        fill_in "Email", with: "wrong"
        click_button "Submit"
      }.not_to change( ActionMailer::Base.deliveries, :size )

      expect( page ).to have_content "Email address not found"
    end
  end

  context "given valid email address on new page" do
    scenario "only one mail will be sent" do
      visit new_password_reset_path

      expect{
        fill_in "Email", with: archer.email
        click_button "Submit"
      }.to change( ActionMailer::Base.deliveries, :size ).by( 1 )
    end
  end

  scenario "password resets" do
    visit new_password_reset_path

    expect{
      fill_in "Email", with: "wrong"
      click_button "Submit"
    }.not_to change( ActionMailer::Base.deliveries, :size )
    expect( page ).to have_content "Email address not found"

    expect{
      fill_in "Email", with: archer.email
      click_button "Submit"
    }.to change( ActionMailer::Base.deliveries, :size ).by( 1 )
    expect( current_path ).to eq root_path

    regex = %r|(?<=password_resets/)[\w-]*(?=/edit)|
    reset_token = regex.match(
      ActionMailer::Base.deliveries.last.body.encoded )[ 0 ]

    visit edit_password_reset_path( reset_token,
                                    email: "bad" )
    expect( current_path ).to eq root_path

    archer.toggle!( :activated )
    expect( current_path ).to eq root_path
    
    archer.toggle!( :activated )
    visit edit_password_reset_path( "fewafeae",
                                    email: archer.email )
    expect( current_path ).to eq root_path
    
    visit edit_password_reset_path( reset_token,
                                    email: archer.email )

    expect( find( "input[name=email]", visible: false ).value ).to eq archer.email

    fill_in "Password", with: "abcdefg"
    fill_in "Confirmation", with: "aaaaaaa"
    click_button "Update password"
    expect( page) .to have_selector "div#error_explanation"

    fill_in "Password", with: ""
    fill_in "Confirmation", with: ""
    click_button "Update password"
    expect( page ).to have_selector "div#error_explanation"

    fill_in "Password", with: "foobaz"
    fill_in "Confirmation", with: "foobaz"
    click_button "Update password"
    expect( page ).not_to have_selector "div#error_explanation"
    expect( page ).not_to have_content "Log in"
    expect( current_path ).to eq user_path( archer )

    visit edit_password_reset_path( reset_token,
                                    email: archer.email )
    expect( current_path ).to eq root_path
    expect( archer.reload.reset_digest ).to eq nil
  end

  scenario "password reset fails because digest is expired" do
    archer = create( :archer )

    visit new_password_reset_path

    fill_in "Email", with: archer.email
    click_button "Submit"

    regex = %r|(?<=password_resets/)[\w-]*(?=/edit)|
    reset_token = regex.match(
      ActionMailer::Base.deliveries.last.body.encoded )[ 0 ]

    archer.update_attribute( :reset_sent_at, 3.hours.ago )

    visit edit_password_reset_path( reset_token,
                                    email: archer.email )
    expect( current_path ).to eq new_password_reset_path
    expect( page ).to have_content "Password reset has expired."
  end
end
