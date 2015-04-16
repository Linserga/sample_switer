require 'rails_helper'

RSpec.describe "UsersEdits", type: :request do
  
  let(:user) { FactoryGirl.create(:user)}

  it 'unsuccessful edit' do
    post login_path, session: { email: user.email, password: user.password }
  	get edit_user_path(user)
  	expect(response).to render_template('users/edit')
  	put user_path(user), user: { name: '',
  																			email: 'foo@invalid',
  																			password: 'foo',
  																			password_confirmation: 'bar'
  																		}
  	expect(response).to render_template('users/edit')
  end

  it 'successful edit with friendly forwarding' do
    get edit_user_path(user)
    post login_path, session: { email: user.email, password: user.password }
  	expect(response).to redirect_to edit_user_path(user)
  	put user_path(user), user: { name: 'Name',
  																email: 'newmail@example.com',
  																password: "",
  																password_confirmation: ""
  															}
  	expect(response).to redirect_to user
  	user.reload
  	expect(user.name).to eq('Name')
  	expect(user.email).to eq('newmail@example.com')
  end
end
