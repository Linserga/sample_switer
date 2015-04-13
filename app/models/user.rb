class User < ActiveRecord::Base
	attr_accessor :remember_token
	has_secure_password
	before_save { self.email = self.email.downcase }
	validates :name, presence: true, length: { maximum: 50 }
	validates :password, length: {minimum:3}
	validates :email, presence: true, 
										format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, 
										length: {maximum: 50}, 
										uniqueness: { case_sensitive: false }

	def self.digest(string)
		BCrypt::Password.create(string)
	end

	def self.new_token
		SecureRandom.urlsafe_base64
	end

	def remember
		self.remember_token = User.new_token
		self.update_attribute(:remember_digest, User.digest(self.remember_token))
	end

	def forget
		self.update_attribute(:remember_digest, nil)
	end

	def authenticated?(attribute, token)
		digest = self.send("#{attribute}_token")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(remember_token)
	end
end
