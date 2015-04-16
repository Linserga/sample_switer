require 'rails_helper'

RSpec.describe UsersController, type: :controller do

	let(:user) {FactoryGirl.create(:user)}
	let(:other_user) { FactoryGirl.create(:user, email: 'other@mail.ru')}

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  it 'should redirect index when not logged in' do
    get :index
    expect(response).to redirect_to(login_url)
  end

  it 'should redirect edit when not logged in' do
  	get :edit, id: user
  	expect(flash).not_to be_empty
  	expect(response).to redirect_to(login_url)
  end

  it 'should redirect update when not logged in' do
  	patch :update, id: user, user: { name: user.name, email: user.email }
  	expect(flash).not_to be_empty
  	expect(response).to redirect_to(login_url)
  end

  it 'should redirect edit when logged in as wrong user' do
  	session[:user_id] = other_user.id
  	get :edit, id: user
  	expect(response).to redirect_to(root_url)
  end

  it 'should redirect update when logged in as wrong user' do
  	session[:user_id] = other_user.id
  	patch :update, id: user, user: { name: user.name, email: user.email }
  	expect(response).to redirect_to(root_url)
  end

  it 'should redirect destroy when not logged in' do
    delete :destroy, id: user
    # expect do
    #   delete :destroy, id: user
    # end.not_to change(User, :count)
    expect(response).to redirect_to(login_url)
  end

  it 'should redirect destroy when logged in as non-admin' do
    session[:user_id] = other_user.id
    delete :destroy, id: other_user
    # expect do
    #   delete :destroy, id: user
    # end.not_to change(User, :count)
    expect(response).to redirect_to root_url
  end
end
