# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([ {:name => 'Chicago' }, {:name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

member = Member.create!(name: 'tester', email: 'tester@test.com',
                        password: 'tester',
                        hashed_password: Digest::SHA1.hexdigest('tester'), picture_id: 1)
puts member.inspect