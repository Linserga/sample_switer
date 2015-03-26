require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

	context 'full title' do
		it 'returns full title' do
			expect(full_title 'About').to match('About | Ruby on Rails Tutorial Sample App')
		end

		it 'returns base title if no page title provided' do
			expect(full_title).to match('Ruby on Rails Tutorial Sample App')
		end
	end
end