class User < ActiveRecord::Base
	has_secure_password
	before_save { self.email = self.email.downcase }
	validates :name, presence: true, length: { maximum: 50 }
	validates :password, length: {minimum:3}
	validates :email, presence: true, 
										format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, 
										length: {maximum: 50}, 
										uniqueness: { case_sensitive: false }
end
