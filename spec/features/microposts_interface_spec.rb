require "rails_helper"

feature "Microposts interface" do
  scenario "confirm procedure" do
    archer = create( :archer )
    
    visit login_path
    fill_in "Email", with: archer.email
    fill_in "Password", with: archer.password
    click_button "Log in"

    visit root_path

    expect( page ).to have_selector "input[type=file]"

    expect{
      fill_in "micropost[content]", with: ""
      click_button "Post"
    }.not_to change( archer.microposts, :count )
    expect( page ).to have_selector "div#error_explanation"

    expect{
      fill_in "micropost[content]", with: "This is OK"
      attach_file "micropost[picture]", "spec/rails.png"
      click_button "Post"
    }.to change( archer.microposts, :count ).by( 1 )
    expect( current_path ).to eq root_path
    expect( page.body ).to match "This is OK"
    expect( archer.microposts.first ).to be_picture

    added_post = archer.microposts.first
    expect{
      within "#micropost-#{ added_post.id }" do
        click_link "delete"
      end
    }.to change( archer.microposts, :count ).by( -1 )

    lana = create( :lana )

    visit user_path( lana )
    expect( page ).not_to have_selector "a", text: "delete"
  end

  scenario "micropost sidebar count" do
    archer = create( :archer )

    visit login_path
    fill_in "Email", with: archer.email
    fill_in "Password", with: archer.password
    click_button "Log in"

    visit root_path

    expect( page.body ).to match "#{ archer.microposts.count } microposts"

    lana = create( :lana )
    visit login_path
    fill_in "Email", with: lana.email
    fill_in "Password", with: lana.password
    click_button "Log in"

    visit root_path

    expect( page.body ).to match "0 microposts"

    # lana.microposts.create!( content: "a micropost" )
    # visit root_path

    fill_in "micropost[content]", with: "a micropost"
    click_button "Post"
    expect( page.body ).to match "1 micropost"
  end
end
