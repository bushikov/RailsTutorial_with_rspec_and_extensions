require "rails_helper"

feature "Micropost reply" do
  context "when from following user" do
    scenario "both users can see the reply" do
      create( :one_side )
      following_user = User.first
      followed_user = User.second

      visit login_path
      fill_in "Email", with: following_user.email
      fill_in "Password", with: "password"
      click_button "Log in"

      content = "@#{ followed_user.name }\nHello"

      visit root_path
      fill_in "micropost[content]", with: content
      click_button "Post"

      expect( page ).to have_content( content )

      click_link "Log out"

      visit login_path
      fill_in "Email", with: followed_user.email
      fill_in "Password", with: "password"
      click_button "Log in"

      visit root_path
      expect( page ).to have_content( content )
    end
  end

  context "when from followed user" do
    scenario "both users can see the reply" do
      create( :one_side )
      following_user = User.first
      followed_user = User.second

      visit login_path
      fill_in "Email", with: followed_user.email
      fill_in "Password", with: "password"
      click_button "Log in"

      content = "@#{ following_user.name }\nHello"

      visit root_path
      fill_in "micropost[content]", with: content
      click_button "Post"

      expect( page ).to have_content( content )

      click_link "Log out"

      visit login_path
      fill_in "Email", with: following_user.email
      fill_in "Password", with: "password"
      click_button "Log in"

      visit root_path

      expect( page ).to have_content( content )
    end
  end

  context "when from mutual following users" do
    scenario "both users can see the reply" do
      create( :mutual_follow )
      user1 = User.first
      user2 = User.second


      visit login_path
      fill_in "Email", with: user1.email
      fill_in "Password", with: "password"
      click_button "Log in"

      content = "@#{ user2.name }\nHello"

      visit root_path
      fill_in "micropost[content]", with: content
      click_button "Post"

      expect( page ).to have_content( content )

      click_link "Log out"

      visit login_path
      fill_in "Email", with: user1.email
      fill_in "Password", with: "password"
      click_button "Log in"

      visit root_path

      expect( page ).to have_content( content )
    end
  end

  context "regarding the reply" do
    let( :archer ){ create( :archer ) }

    scenario "even follower can't see the reply" do
      create( :one_side )
      following_user = User.first
      followed_user = User.second
      
      visit login_path
      fill_in "Email", with: followed_user.email
      fill_in "Password", with: "password"
      click_button "Log in"

      visit root_path
      content = "@#{ archer.name }\nHello"
      fill_in "micropost[content]", with: content
      click_button "Post"

      click_link "Log out"

      visit login_path
      fill_in "Email", with: following_user.email
      fill_in "Password", with: "password"
      click_button "Log in"

      visit root_path

      expect( page ).not_to have_content( content )
    end
  end
end
