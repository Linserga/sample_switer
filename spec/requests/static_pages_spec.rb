require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  
  subject {page}

  before {
  	@base_title = "Ruby on Rails Tutorial Sample App"
  }

  shared_examples_for 'all static pages' do
    it { should have_title(full_title(page_title))}
  end

  describe "GET /static_pages" do
    it "returns success status" do
      get root_path 
      assert_template 'static_pages/home'     
      expect(response).to have_http_status(200)
    end
  end

  # Using it
  context "Home page" do
  	it 'should have content Sample App' do
  		visit root_path
      expect(page).to have_xpath("//a[@href='#{root_path}']", count: 2)
      expect(page).to have_xpath("//a[@href='#{about_path}']")
      expect(page).to have_link('Help', href: help_path)
  		expect(page).to have_title(full_title("Home"))
  	end
  end

  # Using context
  context 'Help page' do
  	before {
  		visit help_path
  	}

    it { should have_xpath("//a[@href='#{root_path}']", count: 2) }
    it { should have_link('Help', href: help_path) }
  	it { should have_title(full_title("Help"))}
  end

  # Using shared examples
  context 'About page' do
    let(:page_title) {'About'}

  	before {
  		visit about_path
  	}

  	it_should_behave_like 'all static pages'
  end

  context 'Signup page' do
    before {
      visit signup_path
    }

    it { should have_title(full_title('Sign Up'))}
  end
end
