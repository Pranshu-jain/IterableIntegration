# db/seeds.rb

# Create Users
User.create!(email: 'user1@example.com', password: 'password', password_confirmation: 'password', name: 'User 1', confirmation_token: "qwerty")
User.create!(email: 'user2@example.com', password: 'password', password_confirmation: 'password', name: 'User 2', confirmation_token: "abcdef")

# Create Events
User.all.each do |user|
  user.events.create(title: 'EventA', description: 'Description for EventA by #{user.name}')
  user.events.create(title: 'EventB', description: 'Description for EventB by #{user.name}')
end

puts 'Seed data created successfully!'
