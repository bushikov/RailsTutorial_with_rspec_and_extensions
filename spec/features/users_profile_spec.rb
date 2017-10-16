require "rails_helper"

feature "Users profile" do
  include ApplicationHelper

  scenario "profile display" do
    archer = create( :archer )

    login( archer )

    expect( page ).to have_title( full_title( archer.name ) )
    expect( page ).to have_selector( "h1", text: archer.name )
    expect( page ).to have_selector( "h1>img.gravatar" )
    expect( page.body ).to match( archer.microposts.count.to_s )
    expect( page ).to have_selector( "div.pagination", count: 1 )
    
    archer.microposts.paginate( page: 1 ).each do | post |
      expect( page.body ).to match( post.content )
    end
  end
end
