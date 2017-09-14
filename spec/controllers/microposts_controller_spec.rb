require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  describe "#create" do
    context "when not logged in" do
      it "doesn't create new micropost" do
        expect{
          post :create, params: { micropost:
                                 { content: "Lorem ipsum" } }
        }.not_to change( Micropost, :count )
      end

      it "redirects to login url" do
        post :create, params: { micropost:
                                { content: "Lorem ipsum" } }
        expect( response ).to redirect_to login_url
      end
    end
  end

  describe "#destroy" do
    context "when not logged in" do
      it "doesn't decrease microposts" do
        archer = create( :archer )
        micropost = archer.microposts[ 0 ]

        expect{
          delete :destroy, params: { id: micropost.id }
        }.not_to change( Micropost, :count )
      end

      it "redirects to log in url" do
        archer = create( :archer )
        micropost = archer.microposts[ 0 ]

        delete :destroy, params: { id: micropost.id }
        expect( response ).to redirect_to login_url
      end
    end

    context "when destroying other user's micropost" do
      before do
        @lana = create( :lana )
        @archer = create( :archer )
        log_in_as( @lana )
      end
      it "can't destoy it" do
        expect{
          delete :destroy, params: { id: @archer.microposts[ 0 ].id }
        }.not_to change( Micropost, :count )
      end

      it "redirects to root_url" do
        delete :destroy, params: { id: @archer.microposts[ 0 ].id }
        expect( response ).to redirect_to root_url
      end
    end
  end
end
