# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name: "Daniel Goldberg", email: "danpaulgo@aol.com", password: "BayShore61893", admin: true, activated: true, activated_at: Time.zone.now)

100.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name, email: email, password: password, password_confirmation: password, activated: true, activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do 
  users.each{|u| u.microposts.create!(content: Faker::ChuckNorris.fact[0..139])}
end

# Relationship seeds
users = User.all
user = User.first
following = users[2..40]
followers = users[10..50]
following.each{|f| user.follow(f)}
followers.each{|f| f.follow(user)}
