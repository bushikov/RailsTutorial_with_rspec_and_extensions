require "rails_helper"

RSpec.describe SessionsHelper do
  describe "#current_user" do
    context "when session is nil but cookies contain user id" do
      it "returns right user" do
        user = create( :user )
        remember( user )

        expect( current_user ).to eq user
      end
    end

    context "when session and cookies are nil" do
      it "returns nil" do
        user = create( :user )
        expect( current_user ).to eq nil
      end
    end

    context "when session is nil and cookies have wrong digest" do
      it "returns nil" do
        user = create( :user )
        remember( user )
        cookies[ :remember_token ] = "abc"
        expect( current_user ).to eq nil
      end
    end
  end
end
