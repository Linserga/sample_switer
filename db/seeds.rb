# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(
	name: 'Serge',
	email: 'example@railstutorial.org',
	password: '123',
	password_confirmation: '123',
	admin: true,
	activated: true,
	activated_at: Time.now.to_datetime
	)


99.times do |n|
	User.create!(
		name: Faker::Name.name,
		email: "example-#{n+1}@railstutorial.org",
		password: 'password',
		password_confirmation: 'password',
		activated: true,
		activated_at: Time.now.to_datetime
	)
end

puts "***DONE***"