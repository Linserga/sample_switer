module Utilities
	def is_logged_in?
		!session[:user_id].nil?
	end

	def log_in_as user, options = {}
		password = options[:password] || 'password'
		remember_me = options[:remember_me] || '1'

		if options[:no_capybara]
			session[:user_id] = user.id
		else
			post login_path, session: { email: user.email, password: user.password, remember_me: remember_me}
		end
	end	
end