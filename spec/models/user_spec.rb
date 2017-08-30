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
end
