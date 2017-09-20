require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let( :archer){ create( :archer ) }
  let( :lana){ create( :lana ) }
  
  describe "validation" do
    let( :rel ){ Relationship.new( follower_id: archer.id,
                                   followed_id: lana.id ) }
    
    context "given both id" do
      it "is valid" do
        expect( rel ).to be_valid
      end
    end

    context "given just follower id" do
      it "is invalid" do
        rel.followed_id = nil
        expect( rel ).not_to be_valid
      end
    end

    context "given just followed id" do
      it "is invalid" do
        rel.followed_id = nil
        expect( rel ).not_to be_valid
      end
    end
  end

  describe "#follow" do
    it "adds to the relavant relationships count" do
      expect{
        archer.follow( lana )
      }.to change( Relationship, :count ).by( 1 )
    end
  end

  describe "#following?" do
    context "when the user follows the other" do
      it "returns true" do
        archer.follow( lana )
        expect( archer.following?( lana ) ).to eq true
      end
    end

    context "when the user doesn't follow any one" do
      it "returns false" do
        expect( archer.following?( lana ) ).to eq false
      end
    end
  end

  describe "#followers" do
    context "when the user follows the other" do
      it "contains the other followed" do
        archer.follow( lana )
        expect( lana.followers ).to include( archer )
      end
    end
  end
end
