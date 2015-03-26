class Bug < ActiveRecord::Base
  establish_connection(
    :adapter  => "mysql2",
    :host     => "todo_bugzilla_server_address",
    :username => "todo_username",
    :password => "todo_password",
    :database => "bugs"
  )

  self.primary_key = "bug_id"

  belongs_to :profile, foreign_key: :reporter
end