require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do
  subject { request }

  context 'invalid submission' do
  	it 'should not create user with invalid params' do
  		get signup_path
  		expect do
  			post users_path, user: { name: '', email: 'user@invalid', password: '123', password_confirmation: 'bar'}
  		end.not_to change(User, :count)

      expect(response).to render_template(:new)
      expect(response.body).to include('alert alert-danger')
      expect(response.body).to include('error_explanation')
  	end
  end

  context 'valid submission' do
  	it 'should create user with valid params' do
  		get signup_path
  		
  		expect do
  			post users_path, user: {name: 'serge', email: 'user@mail.com', password: '123', password_confirmation: '123'}
  		end.to change(User, :count).by(1)  	

  		user = User.find_by(email: 'user@mail.com')

  		expect(response).to redirect_to(user)
  		follow_redirect!
  		expect(response).to render_template('users/show')
      expect(is_logged_in?).to eq(true)
      expect(response.body).to include('alert alert-success')
      expect(response.body).to include('Welcome to the Sample App')
  	end
  end
end
