require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  context 'login with invalid info' do
  	it 'does not login user with invalid info' do
  		get login_path
  		expect(response).to render_template('sessions/new') 
  		post login_path, session: { email: '', password: ''} 		
  		expect(response).to render_template('sessions/new')
  		expect(flash).not_to be_empty
  		get root_path
  		expect(flash).to be_empty
  	end
  end

  context 'login with valid info followed by logout' do
    let(:user) { FactoryGirl.create(:user)}    

    it 'should login user' do
      get login_path
      post login_path, session: { email: user.email, password: user.password }
      expect(is_logged_in?).to eq(true)
      expect(response).to redirect_to user
      follow_redirect!
      expect(response).to render_template('users/show')
      expect(response.body).to include('Log out')
      expect(response.body).not_to match('Log in')

      delete logout_path
      expect(is_logged_in?).to eq(false)
      expect(response).to redirect_to root_url
      follow_redirect!
      expect(response.body).to include('Log in')
      expect(response.body).not_to match('Log out')

      delete logout_path
      follow_redirect!
      expect(response.body).to match('Log in')
      expect(response.body).not_to match('Log out')
      expect(response.body).not_to match('Profile')
    end
  end

  # context 'testing with remeber_me' do
  #   let(:user) { FactoryGirl.create(:user)}

  #   it 'should login with remembering' do
  #     log_in_as user, remember_me: '1'
  #     expect(cookies['remember_token']).not_to be_nil
  #   end
  # end
end
