module Utilities
	def is_logged_in?
		!session[:user_id].nil?
	end

	def log_in_as(user, options = {})
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    check('Remember me on this computer') if options[:remember_me]  == '1'                     
    click_button 'Log in'
  end
end