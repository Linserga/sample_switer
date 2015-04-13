require 'rails_helper'

RSpec.describe User, type: :model do
	let(:user) {FactoryGirl.create(:user)}

	subject {user}

	it { should be_valid}

	context 'without name it should not be valid' do
		before {user.name = ""}
		it { should_not be_valid }
	end

	context 'without email it should not be valid' do
		before {user.email = ''}
		it { should_not be_valid }
	end

	context 'email should not be too long' do
		before {user.email = 'a' * 244 + '@example.com'}
		it { should_not be_valid}
	end

	context 'name should not be too long' do
		before {user.name = 'a' * 51}
		it { should_not be_valid}
	end

	it 'should be valid when email format is correct' do
		addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]

		addresses.each do |address| 
			user.email = address
			expect(user).to be_valid, "#{address.inspect} should be valid"
		end		
	end

	it 'should not be valid when email format is incorrect' do
		invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]

		invalid_addresses.each do |address|
			user.email = address
			expect(user).not_to be_valid, "#{address.inspect} should be invalid"
		end                           
	end

	it 'duplicate user' do
		user = FactoryGirl.build(:user)
		duplicate_user = user.dup
		duplicate_user.email = user.email.upcase
		duplicate_user.save
		
		expect(user).not_to be_valid
	end

	context 'password should be longer than 2 chars' do
		before {
			user.password = user.password_confirmation = '1'
		}

		it { should be_invalid }
	end

	context 'authenticate method' do
		let(:found_user) { User.find_by(email: user.email)}
		it { should eq found_user.authenticate(user.password)}
	end

	context 'email with mixed case' do
		let(:email_with_mixed_case) {'FoMas@com.Ru'}
		before {
			user.email = email_with_mixed_case
			user.save
		}
		its(:email) { should eq email_with_mixed_case.downcase}
	end

	it { expect(user.authenticated?(:remember, '')).to eq(false)}
end