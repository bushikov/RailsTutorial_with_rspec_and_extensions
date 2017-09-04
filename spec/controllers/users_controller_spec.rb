require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let( :valid_user ){ { user: { name: "abcdef",
                                email: "abc@abc.com",
                                password: "foobar",
                                password_confirmation: "foobar" } } }

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "given invalid input" do
      it "renders :new" do
        post :create, params: { user: { name: "",
                                        email: "user@invalid",
                                        password: "foo",
                                        password_confirmation: "bar" } }
        expect( response ).to render_template :new
      end
    end

    context "given valid input" do
      it "redirects to :show" do
        post :create, params: valid_user
        expect( response ).to redirect_to user_path( 1 )
        expect( flash ).not_to be_empty
      end

      it "results in logged in" do
        post :create, params: valid_user
        expect( is_logged_in? ).to eq true
      end
    end
  end
end
