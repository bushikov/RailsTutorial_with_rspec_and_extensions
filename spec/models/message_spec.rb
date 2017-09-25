require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "#sender" do
    it "returns the user who sent a message" do
      archer = create( :archer )
      lana = create( :lana )
      message = Message.new( sender_id: archer.id,
                             receiver_id: lana.id )
      expect( message.sender ).to eq archer
    end
  end
  describe "#receiver" do
    it "returns the user who received a message" do
      archer = create( :archer )
      lana = create( :lana )
      message = Message.new( sender_id: archer.id,
                             receiver_id: lana.id )
      expect( message.receiver ).to eq lana
    end
  end
end
