require "rails_helper"

feature "Users Edit" do
  feature "when accessing edit page without logged in followed by access with logged in" do
    scenario "successful access to edit page with flendly forwarding" do
      user = create( :user )

      visit edit_user_path( user )
      
      login( user )

      expect( current_path ).to eq edit_user_path( user )
    end
  end

  feature "when accessing some not allowing page without permission followed by access with logged in" do
    scenario "successful access to the last page you attempted to access" do
      user = create( :user )

      visit user_path( user )
      visit edit_user_path( user )

      login( user )

      expect( current_path ).to eq edit_user_path( user )
    end
  end

  feature "when accessing on login page at first place" do
    scenario "successful access to the user page" do
      user = create( :user )

      login( user )

      expect( current_path ).to eq user_path( user )
    end
  end
end
