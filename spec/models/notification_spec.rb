require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "#valid?" do
    let( :archer ){ create( :archer ) }
    context "not given type" do
      it "returns false" do
        notification = Notification.new( user_id: archer.id )
        expect( notification ).not_to be_valid
      end
    end
    context "not given content" do
      it "returns true" do
        notification = Notification.new( user_id: archer.id,
                                         type: 1 )
        expect( notification ).to be_valid
      end
    end
    context "given type" do
      it "returns true" do
        notification = Notification.new( user_id: archer.id,
                                         type: 1 )
        expect( notification ).to be_valid
      end
    end
  end

  describe "#user" do
    let( :archer ){ create( :archer ) }
    it "returns user who user_id points" do
      notification = Notification.new( user_id: archer.id,
                                       type: 1 )
      expect( notification.user ).to eq archer
    end
  end
end