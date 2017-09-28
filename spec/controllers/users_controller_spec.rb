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
        expect( response ).to redirect_to root_url
        expect( flash ).not_to be_empty
      end

      it "results in not logged in yet" do
        post :create, params: valid_user
        expect( is_logged_in? ).to eq false
      end

      specify "new user is not activated yet" do
        post :create, params: valid_user
        expect( assigns( :user ) ).not_to be_activated
      end
    end
  end

  describe "GET #edit" do
    context "given valid id" do
      it "renders edit page" do
        user = create( :user )
        log_in_as( user )
        get :edit, params: { id: user.id }
        expect( response ).to render_template :edit
      end

      it "makes flash have messages" do
        user = create( :user )
        get :edit, params: { id: user.id }
        expect( flash ).not_to be_empty
      end
    end

    context "when user accesses other user's edit page" do
      let( :user ){ create( :user ) }
      let( :archer){ create( :archer ) }
      before do
        log_in_as( archer )
        get :edit, params: { id: user.id }
      end
      it "doesn't make flash have any error messages" do
        expect( flash ).to be_empty
      end

      it "redirects root url" do
        expect( response).to redirect_to root_url
      end
    end
  end

  describe "PATCH #update" do
    context "given invalid information" do
      it "renders edit page" do
        user = create( :user )

        log_in_as( user )

        patch :update, params: { user: { name: "",
                                         email: "foo@invalid",
                                         password: "foo",
                                         password_confirmation: "bar" },
                                 id: user.id }

        expect( response ).to render_template :edit
        expect( assigns( :user ).errors.count ).to eq 4
      end
    end

    context "when not logged in" do
      it "redirects log in page " do
        user = create( :user )
        patch :update, params: { id: user.id,
                                 user: { name: user.name,
                                         email: user.email } }
        expect( response ).to redirect_to login_url
      end
    end

    context "given valid information" do
      let( :user ){ create( :user ) }

      before do
        log_in_as user
        patch :update, params: { id: user.id,
                                 user: { name: "Foo Bar",
                                         email: "foo@bar.com",
                                         password: "",
                                         password_confirmation: "" } }
      end

      it "redirects show page " do
        expect( response ).to redirect_to user_path( user.id )
      end

      specify "flash is not empty" do
        expect( flash ).not_to be_empty
      end

      it "saves new information at DB" do
        user2 = User.find( user.id )
        expect( user2.name ).to eq "Foo Bar"
        expect( user2.email ).to eq "foo@bar.com"
      end
    end

    context "when user edits other user information" do
      let( :user ){ create( :user ) }
      let( :archer ){ create( :archer ) }
      before do
        log_in_as( archer )
        patch :update, params: { id: user.id,
                                 user: { name: user.name,
                                         email: user.email } }
      end
      it "doesn't make flash have any messages" do
        expect( flash ).to be_empty
      end
      it "redirects root_url" do
        expect( response ).to redirect_to root_url
      end
    end

    context "when user send request maliciously" do
      it "doesn't allow updating db" do
        user = create( :user )
        log_in_as( user )
        patch :update, params: { id: user.id,
                                 user: { name: user.name,
                                         email: user.email,
                                         admin: 1 } }
        expect( user.reload ).not_to be_admin
      end
    end
  end

  describe "GET #index" do
    context "when not logged in" do
      it "redirects login_url" do
        get :index
        expect( response ).to redirect_to login_url
      end
    end
  end

  describe "DELETE #destroy" do
    context "when not logged in" do
      it "doesn't allow operation and redirects to root_url" do
        archer = create( :archer )
        
        expect{
          delete :destroy, params: { id: archer.id }
        }.not_to change( User, :count )

        expect( response ).to redirect_to login_url
      end
    end

    context "when logged in as forbidden user" do
      it "doesn't allow operation and redirects to root_url" do
        user = create( :user )
        archer = create( :archer )
        log_in_as( archer )

        expect{
          delete :destroy, params: { id: user }
        }.not_to change( User, :count )

        expect( response ).to redirect_to root_url
      end
    end
  end

  describe "GET #following" do
    let( :archer ){ create( :archer ) }
    let( :lana ){ create( :lana ) }

    context "when not logged in" do
      it "redirects to login url" do
        get :following, params: { id: archer.id }
        expect( response ).to redirect_to login_url
      end
    end
  end

  describe "GET #followers" do
    let( :archer ){ create( :archer ) }
    let( :lana ){ create( :lana ) }

    context "when not logged in" do
      it "redirects to login url" do
        get :followers, params: { id: archer.id }
        expect( response ).to redirect_to login_url
      end
    end
  end

  describe "GET #messages" do
    let( :archer ){ create( :archer ) }
    let( :lana ){ create( :lana ) }

    before do
      archer.follow( lana )
      lana.follow( archer )
    end
    
    context "when not logged in" do
      it "redirects to login url" do
        get :messages, params: { id: archer.id }
        expect( response ).to redirect_to login_url
      end
    end

    context "when logged in as third party" do
      let( :malory ){ create( :malory ) }
      let( :message ){ archer.sending.create( receiver_id: lana.id,
                                              content: "Hello" ) }
      before do
        message
        log_in_as( malory )
      end

      it "redirects to root url" do
        get :messages, params: { id: archer.id }
        expect( response ).to redirect_to root_url
      end
    end

    context "when logged in" do
      let( :message ){ archer.sending.create( receiver_id: lana.id,
                                              content: "Hello" ) }
      before do
        log_in_as( archer )
        message
        get :messages, params: { id: archer.id }
      end

      it "assigns @messages to messages" do
        expect( assigns( :messages ) ).to include message
      end

      it "renders messages" do
        expect( response ).to render_template :messages
      end
    end
  end
end
