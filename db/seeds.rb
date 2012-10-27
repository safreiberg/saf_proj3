# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(:username => "saf", :email => "saf@mit.edu", :password => "a")
User.create(:username => "user2", :email => "user2@user.com", :password => "a")
User.create(:username => "admin", :email => "admin@admin.com", :password => "a")

Post.create(:content => "And I feel fine.", :user_id => 1, :title => "It's the end of our world as we know it.")
Post.create(:content => "Turn all of the lights off over every boy and every girl", :user_id => 2, :title => "Closing time.")
Post.create(:content => "You look wonderful tonight", :user_id => 1, :title => "And I said yes,")