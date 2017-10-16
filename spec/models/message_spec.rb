require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "#sender" do
    it "returns the user who sent a message" do
      archer = create( :archer )
      lana = create( :lana )
      archer.follow( lana )
      lana.follow( archer )
      message = Message.create( sender_id: archer.id,
                                receiver_id: lana.id,
                                content: "a" )
      message.reload
      expect( message.sender ).to eq archer
    end
  end
  
  describe "#receiver" do
    it "returns the user who received a message" do
      archer = create( :archer )
      lana = create( :lana )
      archer.follow( lana )
      lana.follow( archer )
      message = Message.create( sender_id: archer.id,
                                receiver_id: lana.id,
                                content: "a" )
      message.reload
      expect( message.receiver ).to eq lana
    end
  end

  describe "#valid?" do
    context "not given sender and receiver id" do
      let( :message ){ Message.new( content: "a" ) }
      it "returns false" do
        expect( message ).not_to be_valid
      end

      specify "Message has some error messages" do
        message.valid?
        expect( message.errors.messages ).to \
          include( sender_id: [ "can't be blank" ],
                   receiver_id: [ "can't be blank" ],
                   sender: [ "must exist" ],
                   receiver: [ "must exist" ] )
      end
    end

    context "given blank to content" do
      let( :message ){ build( :message, content: "" ) }
      it "returns false" do
        expect( message ).not_to be_valid
      end

      specify "Message has some error messages" do
        message.valid?
        expect( message.errors.messages ).to \
          include( content: [ "can't be blank" ] )
      end
    end

    context "given over 140 characters to content" do
      let( :message ){ build( :message, content: "a" * 141 ) }
      it "returns false" do
        expect( message ).not_to be_valid
      end

      specify "Message has some error messages" do
        message.valid?
        expect( message.errors.messages ).to \
          include( content: [ "is too long (maximum is 140 characters)" ] )
      end
    end

    context "given less than or equal 140 characters to content" do
      let( :message ){ create( :message, content: "a" * 140 ) }
      it "returns true" do
        expect( message ).to be_valid
      end
    end

    context "when both not following" do
      let( :archer ){ create( :archer ) }
      let( :lana ){ create( :lana ) }
      let( :message ){ Message.new( content: "a",
                                    sender_id: archer.id,
                                    receiver_id: lana.id ) }
      it "returns false" do
        expect( message ).not_to be_valid
      end
      specify "Message has the error message" do
        message.valid?
        expect( message.errors.messages ).to \
          include( relationship: [ "should be mutual follow" ] )
      end
    end
    
    context "when only sender follows" do
      let( :archer ){ create( :archer ) }
      let( :lana ){ create( :lana ) }
      let( :message ){ Message.new( content: "a",
                                    sender_id: archer.id,
                                    receiver_id: lana.id ) }
      before do
        archer.follow( lana )
      end
      it "returns false" do
        expect( message ).not_to be_valid
      end
      specify "Message has the error message" do
        message.valid?
        expect( message.errors.messages ).to \
          include( relationship: [ "should be mutual follow" ] )
      end
    end
    
    context "when only receiver follows" do
      let( :archer ){ create( :archer ) }
      let( :lana ){ create( :lana ) }
      let( :message ){ Message.new( content: "a",
                                    sender_id: archer.id,
                                    receiver_id: lana.id ) }
      before do
        lana.follow( archer )
      end
      it "returns false" do
        expect( message ).not_to be_valid
      end
      specify "Message has the error message" do
        message.valid?
        expect( message.errors.messages ).to \
          include( relationship: [ "should be mutual follow" ] )
      end
    end

    context "when both following" do
      it "returns true" do
        message = create( :message )
        expect( message ).to be_valid
      end
    end
  end

  describe "<order>" do
    it "is descending by created_at" do
      create( :message )
      second = create( :message )
      
      expect( Message.first ).to eq second
    end
  end

  describe "after save call back" do
    context "when someone sent message to another" do
      it "creates a notification" do
        archer = create( :archer )
        lana = create( :lana )
        archer.follow( lana )
        lana.follow( archer )
        archer.messages.create( receiver_id: lana.id,
                                content: "HELLO" )

        notification = Notification.first
        expect( notification.type ).to eq 2
        expect( notification.content ).to eq "#{ archer.name } sent you a message."
      end
    end
  end
end
