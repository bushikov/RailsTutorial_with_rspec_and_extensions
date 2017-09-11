require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let( :archer ){ user = create( :archer ) }
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

  # describe "password_reset" do
  #   let(:mail) { UserMailer.password_reset }
  #
  #   it "renders the headers" do
  #     expect(mail.subject).to eq("Password reset")
  #     expect(mail.to).to eq(["to@example.org"])
  #     expect(mail.from).to eq(["from@example.com"])
  #   end
  #
  #   it "renders the body" do
  #     expect(mail.body.encoded).to match("Hi")
  #   end
  # end

end
