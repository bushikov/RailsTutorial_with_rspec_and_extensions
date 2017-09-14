require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let( :archer ){ create( :archer ) }
  let( :micropost ){ archer.microposts.build(
                       content: "Lorem ipsum" ) }
  context "given correct attributes" do
    it "is valid" do
      expect( micropost ).to be_valid
    end
  end

  context "user id is nil" do
    it "is invalid" do
      micropost.user_id = nil
      expect( micropost ).not_to be_valid
    end
  end

  context "given blank content" do
    it "is invalid" do
      micropost.content = "  "
      expect( micropost ).not_to be_valid
    end
  end

  context "given too long content" do
    it "is invalid" do
      micropost.content = "a" * 141
      expect( micropost ).not_to be_valid
    end
  end

  context "when there're some not ordered microposts" do
    it "can get ordered microposts" do
      lana = create( :lana )
      create( :two_hours_ago, user_id: lana.id )
      create( :one_days_ago, user_id: lana.id )
      recent = create( :most_recent, user_id: lana.id )
      expect( Micropost.first ).to eq recent
    end
  end

  context "when deleting user" do
    it "deletes micropost belonging to the user simultaneously" do
      lana = create( :lana )
      create( :micropost, user_id: lana.id )
      expect{
        lana.destroy
      }.to change( Micropost, :count ).by( -1 )
    end
  end
end
