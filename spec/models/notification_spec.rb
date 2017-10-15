require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "validation" do
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

  describe "default_scope" do
    context "order" do
      it "is descending order of created_at" do
        archer = create( :archer )
        n1 = Notification.create( user_id: archer.id,
                                 type: 1 )
        n2 = Notification.create( user_id: archer.id,
                                 type: 2 )
        expect( Notification.first ).to eq n2
      end
    end

    context "where" do
      specify "only the one with false on informed will be found" do
        archer = create( :archer )
        lana = create( :lana )
        malory = create( :malory )

        lana.follow( archer )
        malory.follow( archer )

        Notification.first

        expect( Notification.first.content ).to include( lana.name )
      end
    end
  end

  describe "after_find" do
    specify "the one which has been found at least one time won't be found" do
      archer = create( :archer )
      lana = create( :lana )

      Notification.new( type: 1, user_id: archer.id )

      Notification.first

      expect( Notification.first ).to be_nil
    end
  end
end
