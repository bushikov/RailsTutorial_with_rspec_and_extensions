require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
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
