require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "is given remember me" do
      specify "cookies contains remember_me" do
        user = create( :user )

        post :create, params: { session: { email: user.email,
                                           password: user.password,
                                           remember_me: "1" } }

        expect( cookies[ :remember_token ] ).not_to eq nil
      end
    end

    context "is not given remember me" do
      specify "cookies doesn't contain remember_me" do
        user = create( :user )

        post :create, params: { session: { email: user.email,
                                           password: user.password,
                                           remember_me: "0" } }
        
        expect( cookies[ :remember_token ] ).to eq nil
        # expect( assigns( :user ) ).to eq user
      end
    end
  end

  describe "DELETE #destroy" do
    it "results in logged out" do
      user = create( :user )
      session[ :user_id ] = user.id
      # delete :destroy, id: user
      delete :destroy, params: { id: user }
      expect( is_logged_in? ).to eq false
    end
  end
end
