class Profile < ActiveRecord::Base
  establish_connection(
    :adapter  => "mysql2",
    :host     => "todo_bugzilla_server_address",
    :username => "todo_username",
    :password => "todo_password",
    :database => "bugs"
  )

  self.primary_key = "userid"
end