# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ace = Customer.find_or_initialize_by(key: 'ace')
ace.name = 'ACE SOFT'
ace.expires_at = Date.new(2099, 12, 31)
ace.enabled = true
ace.sync_data = true
ace.save!

['thai', 'admin'].each do |username|
  user = User.find_or_initialize_by(username: username)
  user.password = '123456'
  user.role = 'admin'
  user.email = "#{username}@vanct.com"
  user.customer = ace
  user.save!
end

# (1..29).each do |index|
#   day = sprintf '%02d', index
#   Shift.create({ customer_id: 1, no: "1-2024-01-#{day}", stt: "1", total: (200.0 * index) * rand(1000..9000), shift_date: Time.zone.parse("2024-01-#{day}") })
# end
