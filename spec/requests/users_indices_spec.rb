require 'rails_helper'

RSpec.describe "UsersIndices", type: :request do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) {FactoryGirl.create(:user)}

  context 'pagination' do
  	before(:each){ 30.times { FactoryGirl.create(:user)}}
  	after(:each) { User.delete_all}

  	it 'index including pagination' do
  		post login_path, session: { email: user.email, password: user.password } 
  		get users_path
  		expect(response).to render_template('users/index')
  		expect(response.body).to include("pagination")
      # expect do
      #   delete user_path(other_user)
      # end.to change(User, :count).by(-1)
  	end

    it 'should not display delete links to non-admins' do
      post login_path, session: { email: other_user.email, password: other_user.password } 
      visit users_path
      expect(page).not_to have_link('delete')
    end

  	# it 'should list each user' do
  	# 	visit users_path
  	# 	User.paginate(page: 1).each do |user|
  	# 		expect(page).to have_link(user.name, href: user_path(user))
  	# 		expect(page).to have_xpath("//a[@href='#{user_path(user)}']")
  	# 	end
  	# end
  end
end
