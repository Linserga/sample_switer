require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do

	let(:user){FactoryGirl.create(:user)}

  before {
  	ActionMailer::Base.deliveries.clear
  }

  it 'password resets' do
  	get new_password_reset_path
  	expect(response).to render_template('password_resets/new')
  	# Invalid email
  	post password_resets_path, password_reset: { email: ''}
  	expect(flash).not_to be_empty
  	expect(response).to render_template('password_resets/new')
  	# Valid email
  	post password_resets_path, password_reset: { email: user.email}
  	expect(user.reset_digest).not_to eq(user.reload.reset_digest)
  	expect(ActionMailer::Base.deliveries.size).to eq(1)
  	expect(flash).not_to be_empty
  	expect(response).to redirect_to root_url

  	#Password reset form
  	user = assigns(:user)
  	get edit_password_reset_path(user.reset_token, email: '')
  	expect(response).to redirect_to root_url

  	#Inactive user
  	user.toggle!(:activated)
  	get edit_password_reset_path(user.reset_token, email: user.email)
  	expect(response).to redirect_to root_url
  	user.toggle!(:activated)
  	 # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    expect(response).to redirect_to root_url

    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    expect(response).to render_template 'password_resets/edit'
    expect(response.body).to match("<input type=\"hidden\" name=\"email\" id=\"email\" value=\"#{user.email}\"")

    #Invalid password & confirmation
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "foobaz",
                  password_confirmation: "barquux" }
    expect(response.body).to match('error_explanation')

    #Blank password
    patch password_reset_path(user.reset_token),
    	email: user.email,
    	user: { password: '  ',
    					password_confirmation: 'bar'
    				}
    expect(flash).not_to be_empty
    expect(response).to render_template('password_resets/edit')

    #Valid password & confirmation

    patch password_reset_path(user.reset_token),
    	email: user.email,
    	user: { password: 'bar',
    					password_confirmation: 'bar'
    				}
    	expect(is_logged_in?).to eq(true)
    	expect(flash).not_to be_empty
    	expect(response).to redirect_to(user)
  end
end
