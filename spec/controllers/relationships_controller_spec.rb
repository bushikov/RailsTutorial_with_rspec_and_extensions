require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  describe "#create" do
    context "when not logged in" do
      it "doesn't create Relationship" do
        expect{
          post :create
        }.not_to change( Relationship, :count )
      end
    end

    context "when logged in" do
      it "adds to the number of following" do
        archer = create( :archer )
        lana = create( :lana )
        log_in_as( archer )

        expect{
          post :create, params: { followed_id: lana.id }
        }.to change( archer.following, :count ).by( 1 )
      end
    end

    context "when loggd in with Ajax" do
      it "adds to the number of following" do
        archer = create( :archer )
        lana = create( :lana )
        log_in_as( archer )
        
        expect{
          post :create, params: { followed_id: lana.id }, xhr: true
        }.to change{ archer.following.count }.by( 1 )

        # xhr command is deprecated as of Rails 5.1
        # expect{
        #   xhr :create, params: { followed_id: lana.id }
        # }.to change{ archer.following.count }.by( 1 )
      end
    end
  end

  describe "#destroy" do
    context "when not logged in" do
      it "doesn't reduce Relationship" do
        expect{
          delete :destroy, params: { id: create( :archer ).id }
        }.not_to change( Relationship, :count )
      end
    end

    context "when logged in" do
      it "decreases the number of following" do
        archer = create( :archer )
        lana = create( :lana )
        log_in_as( archer )

        archer.follow( lana )

        expect{
          delete :destroy, params: { id: archer.active_relationships[ 0 ].id }
        }.to change{ archer.following.count }.by( -1 )
      end
    end

    context "when logged in with Ajax" do
      it "decreases the number of following" do
        archer = create( :archer )
        lana = create( :lana )
        log_in_as( archer )

        archer.follow( lana )

        expect{
          delete :destroy, xhr: true,
                           params: { id: archer.active_relationships[ 0 ].id }
        }.to change( archer.following, :count ).by( -1 )
      end
    end
  end
end
