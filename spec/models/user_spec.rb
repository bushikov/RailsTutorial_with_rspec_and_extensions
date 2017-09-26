require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new( name: "Example User",
                      email: "user@example.com",
                      password: "foobar",
                      password_confirmation: "foobar" )
  end

  describe "#valid?" do
    context "in case correct name and email" do
      it "returns true" do
        expect( @user ).to be_valid
      end
    end

    context "in case name is blank" do
      it "returns false" do
        @user.name = "   "
        expect( @user ).not_to be_valid
      end
    end

    context "in case email is blank" do
      it "returns false" do
        @user.email = "   "
        expect( @user ).not_to be_valid
      end
    end

    context "in case name is too long" do
      it "returns false" do
        @user.name = "a" * 51
        expect( @user ).not_to be_valid
      end
    end

    context "in case email is too long" do
      it "returns false" do
        @user.email = "a" * 244 + "@example.com"
        expect( @user ).not_to be_valid
      end
    end

    context "in case email is not acceptable" do
      it "returns false" do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
        invalid_addresses.each do | invalid_address |
          @user.email = invalid_address
          expect( @user ).not_to be_valid
        end
      end
    end

    context "in case email is not unique" do
      it "returns false" do
        duplicate_user = @user.dup
        duplicate_user.email = @user.email.upcase
        duplicate_user.save
        @user.save
        expect( @user ).not_to be_valid
      end
    end

    context "in case password is too short" do
      it "returns false" do
        @user.password = @user.password_confirmation = "a" * 5
        # @user.save
        expect( @user ).not_to be_valid
      end
    end

    context "in case password is blank" do
      it "returns false" do
        @user.password = @user.password_confirmation = " " * 6
        expect( @user ).not_to be_valid
      end
    end
  end

  describe "#save" do
    context "in case email inputed is uppercase" do
      it "turns email into lowercase and saves" do
        lower_case = @user.email
        @user.email = @user.email.upcase
        @user.save
        expect( @user.reload.email ).to eq lower_case
      end
    end
  end

  describe "#authenticated?" do
    context "given wrong token" do
      it "returns false" do
        user = create( :user )
        expect( user.authenticated?( :remember, "" ) ).to eq false
      end
    end
  end

  describe "#feed" do
    context "when its own microposts" do
      it "includes its own microposts" do
        archer = create( :archer )

        50.times do
          create( :micropost, user: archer )
        end

        archer.microposts.each do | post |
          expect( archer.feed ).to include( post )
        end
      end
    end

    context "when one follows the other" do
      it "includes following's microposts" do
        archer = create( :archer )
        lana = create( :lana )
        archer.follow( lana )
        50.times do
          create( :micropost, user: lana )
        end

        lana.microposts.each do | post |
          expect( archer.feed ).to include( post )
        end
      end
    end

    context "when one doesn't follow the other" do
      it "doesn't include the other's posts" do
        archer = create( :archer )
        lana = create( :lana )
        50.times do
          create( :micropost, user: lana )
        end
        
        lana.microposts.each do | post |
          expect( archer.feed ).not_to include( post )
        end
      end
    end
  end

  describe "#sending" do
    it "returns the messages user sent" do
      archer = create( :archer )
      lana = create( :lana )
      archer.follow( lana )
      lana.follow( archer )
      message = archer.sending.create( receiver_id: lana.id,
                                       content: "a" )
      message.reload
      expect( archer.sending ).to include message
    end
  end

  describe "#receiving" do
    it "returns the messages user received" do
      archer = create( :archer )
      lana = create( :lana )
      archer.follow( lana )
      lana.follow( archer )
      message = archer.sending.create( receiver_id: lana.id,
                                       content: "a" )
      message.reload
      expect( lana.receiving ).to include message
    end
  end
end
