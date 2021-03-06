require "rails_helper"

feature "Following" do
  shared_context "following" do
    let( :michael ){ create( :michael ) }
    let( :archer ){ create( :archer ) }
    let( :lana ){ create( :lana ) }
    let( :malory ){ create( :malory ) }
    let( :following ){
      michael.follow( lana )
      michael.follow( malory )
      lana.follow( michael )
      archer.follow( michael )
    }
  end
  context "follwoing page" do
    include_context "following"
    scenario "correct following" do
      following
      
      act_as( michael ) do
        visit following_user_path( michael )
        expect( page.body ).to match michael.following.count.to_s

        michael.following.each do | user |
          expect( page ).to have_selector "a[href='#{ user_path( user ) }']"
        end
      end
    end
  end

  context "followers page" do
    include_context "following"
    scenario "correct followers" do
      following

      act_as( michael ) do
        visit followers_user_path( michael )
        expect( page.body ).to match michael.followers.count.to_s

        michael.followers.each do | user |
          expect( page ).to have_selector "a[href='#{ user_path( user ) }']"
        end
      end
    end
  end
end
