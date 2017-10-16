module LoginMacros
  def login( user )
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end

  def logout
    click_link "Log out"
  end

  def act_as( user )
    login( user )
    yield
    logout
  end
end
