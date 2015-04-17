class User < ActiveRecord::Base
	attr_accessor :remember_token, :activation_token, :reset_token
	has_secure_password
	before_save { self.email = self.email.downcase }
	before_create :create_activation_digest
	validates :name, presence: true, length: { maximum: 50 }
	validates :password, length: {minimum:3}, allow_blank: true
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
		digest = self.send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	def create_reset_digest
		self.reset_token = User.new_token
		update_columns(reset_digest: User.digest(self.reset_token), reset_sent_at: Time.now.to_datetime)
	end

	def password_expired?
		self.reset_sent_at < 1.minute.ago
	end

	private
		def create_activation_digest
			self.activation_token = User.new_token
			self.activation_digest = User.digest(self.activation_token)
		end
end
