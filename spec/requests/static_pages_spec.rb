require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  
  subject {page}

  before {
  	@base_title = "Ruby on Rails Tutorial Sample App"
  }

  describe "GET /static_pages" do
    it "returns success status" do
      get root_path
      expect(response).to have_http_status(200)
    end
  end

  context "Home page" do
  	it 'should have content Sample App' do
  		visit root_path
  		expect(page).to have_title("Home | #{@base_title}")
  	end
  end

  context 'Help page' do
  	before {
  		visit static_pages_help_path
  	}

  	it { should have_title("Help | #{@base_title}")}
  end

  context 'About page' do
  	before {
  		visit static_pages_about_path
  	}

  	it { should have_title("About | #{@base_title}")}
  end
end
