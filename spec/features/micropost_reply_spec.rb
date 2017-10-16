require "rails_helper"

feature "Micropost reply" do
  context "when from following user" do
    scenario "both users can see the reply" do
      create( :one_side )
      following_user = User.first
      followed_user = User.second
      
      content = "@#{ followed_user.name }\nHello"

      following_user.password = "password"
      act_as( following_user ) do
        visit root_path
        fill_in "micropost[content]", with: content
        click_button "Post"

        expect( page ).to have_content( content )
      end

      followed_user.password = "password"
      login( followed_user )

      visit root_path
      expect( page ).to have_content( content )
    end
  end

  context "when from followed user" do
    scenario "both users can see the reply" do
      create( :one_side )
      following_user = User.first
      followed_user = User.second

      content = "@#{ following_user.name }\nHello"

      followed_user.password = "password"
      act_as( followed_user ) do
        visit root_path
        fill_in "micropost[content]", with: content
        click_button "Post"

        expect( page ).to have_content( content )
      end

      following_user.password = "password"
      login( following_user )

      visit root_path

      expect( page ).to have_content( content )
    end
  end

  context "when from mutual following users" do
    scenario "both users can see the reply" do
      create( :mutual_follow )
      user1 = User.first
      user2 = User.second

      content = "@#{ user2.name }\nHello"

      user1.password = "password"
      act_as( user1 ) do
        visit root_path
        fill_in "micropost[content]", with: content
        click_button "Post"

        expect( page ).to have_content( content )
      end

      user2.password = "password"
      login( user2 )

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

      content = "@#{ archer.name }\nHello"

      followed_user.password = "password"
      act_as( followed_user ) do
        visit root_path
        fill_in "micropost[content]", with: content
        click_button "Post"
      end
      
      following_user.password = "password"
      login( following_user )

      visit root_path

      expect( page ).not_to have_content( content )
    end
  end
end
