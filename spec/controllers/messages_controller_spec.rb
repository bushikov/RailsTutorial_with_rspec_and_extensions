require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  describe "#create" do
    context "when not logged in" do
      it "redirects to login url" do
        create( :mutual_follow )
        sender = User.first
        receiver = User.second

        post :create, params: { message: { content: "hello",
                                           receiver_id: receiver.id } }
        expect( response ).to redirect_to login_url
      end
    end

    context "when logged in" do
      context "given incorrect message" do
        before do
          create( :mutual_follow )
          @sender = User.first
          receiver = User.second

          log_in_as( @sender )

          post :create, params: { message: { content: "",
                                             receiver_id: receiver.id } }
        end

        it "redirect to message user url" do
          expect( response ).to redirect_to messages_user_url( @sender )
        end

        it "edits failure message to flash" do
          expect( flash[ :danger ] ).to include( "Message couldn't be sent!" )
        end
      end

      context "given correct message" do
        before do
          create( :mutual_follow )
          @sender = User.first
          @receiver = User.second

          log_in_as( @sender )
        end

        it "redirect to message user url" do
          post :create, params: { message: { content: "Hello",
                                             receiver_id: @receiver.id } }
          expect( response ).to redirect_to messages_user_url( @sender )
        end

        it "edits success message to flash" do
          post :create, params: { message: { content: "Hello",
                                             receiver_id: @receiver.id } }
          expect( flash[ :success ] ).to include( "Message sent!" )
        end

        it "adds to Messages" do
          expect{
            post :create, params: { message: { content: "Hello",
                                               receiver_id: @receiver.id } }
          }.to change( Message, :count ).by( 1 )
        end
      end
    end
  end
end
