require 'spec_helper'
require_relative 'helpers/session_helper'

feature 'Submiting absorb rating', :js, :vcr do
  include Features::SessionHelper

  scenario "by pressing the score button after revealing the answer to the question" do
    sign_in_with 'john doe', 'john.doe@gmail.com'
    visit '/top-10'
    find('.show-answer-button').click

    Capybara.ignore_hidden_elements = false
    expect {
      first('.score-button').click
    }.to change {
      #find('.page-header').text #cannot use this as test as only 1 answer returns atm.
      find('.answer').visible?
    }
    Capybara.ignore_hidden_elements = true

  end
end
