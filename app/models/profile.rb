class Profile < ActiveRecord::Base
  establish_connection(
    :adapter  => "mysql2",
    :host     => BUGZILLA_CONFIG["host"],
    :username => BUGZILLA_CONFIG["username"],
    :password => BUGZILLA_CONFIG["password"],
    :database => "bugs"
  )

  self.primary_key = "userid"
end