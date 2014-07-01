require 'spec_helper'

feature 'Guest visitor can start absorbing like any other user', :vcr do

  scenario "by clicking 'get started' before signing in" do
    visit '/'
    click_link 'Get Started'

    expect(current_path).to eq('/top-10')
    expect(find('.navbar')).to have_content /guest/
  end

end
