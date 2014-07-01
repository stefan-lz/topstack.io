module Features
  module SessionHelper
    def sign_in_with user, email
      visit auth_path

      fill_in 'Name', :with => user
      fill_in 'Email', :with => email

      click_button 'Sign In'
    end

    def auth_path
      '/auth/developer'
    end
  end
end
