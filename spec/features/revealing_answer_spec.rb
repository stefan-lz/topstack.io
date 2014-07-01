require 'spec_helper'
require_relative 'helpers/session_helper'

feature 'Revealing the answer', :js, :vcr do
  include Features::SessionHelper

  scenario 'by clicking the show answer button' do
    sign_in_with 'john doe', 'john.dow@gmail.com'
    visit '/top-10'

    expect(page).to have_selector('.hidden.answer', :visible => false)
    find('.show-answer-button').click
    expect(page).to have_selector '.answer', :visible => true
  end
end
