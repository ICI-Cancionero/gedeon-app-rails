# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
account = Account.find_or_create_by(name: "ICI Santiago", subdomain: "ici-santiago")

ActsAsTenant.with_tenant(account) do
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

  puts "Importing songs"
  Rake::Task['songs:import'].invoke
  Rake::Task['songs:sort_by_title'].invoke
end
