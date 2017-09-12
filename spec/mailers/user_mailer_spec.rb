require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let( :archer ){ create( :archer ) }
    let(:mail) { UserMailer.account_activation( archer ) }

    it "renders the headers" do
      expect( mail.subject ).to eq "Account activation"
      expect( mail.to ).to eq [ archer.email ]
      expect( mail.from ).to eq [ "noreply@example.com" ]
    end

    it "renders the body" do
      # body is still object without encoded.
      expect( mail.body.encoded ).to match archer.name
      # expect( mail.body.encoded ).to have_content archer.name
      expect( mail.body.encoded ).to match archer.activation_token
      expect( mail.body.encoded ).to match CGI.escape( archer.email )
    end
  end

  describe "password_reset" do
    let( :archer ){ create( :archer ) }
    let(:mail) { UserMailer.password_reset( archer ) }

    it "renders the headers" do
      archer.reset_token = User.new_token

      expect( mail.subject ).to eq "Password reset"
      expect( mail.to ).to eq [ archer.email ]
      expect( mail.from ).to eq [ "noreply@example.com" ]
    end

    it "renders the body" do
      archer.reset_token = User.new_token

      expect( mail.body.encoded ).to match archer.reset_token
      expect( mail.body.encoded ).to match CGI.escape( archer.email )
    end
  end

end
