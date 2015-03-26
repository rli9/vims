require 'rubygems'
require 'active_record'
require 'action_controller'
require 'action_mailer'
$: << '.'

ActiveRecord::Base.establish_connection(:adapter => "mysql2",
                                        :encoding => "utf8",
                                        :reconnect => "false",
                                        :database => "vims_development",
                                        :username => "vims",
                                        :password => "vims",
                                        :host => "localhost",
                                        :pool => 15)

require 'require_models'
require 'require_helpers'

def audit_remove_invalid_test_cases_of_cm_project
  TestTarget.all.each do |test_target|

    test_cases = test_target.test_cases.select('id, name').sort_by {|tc| tc.id}.reverse
    test_case_names = test_cases.map(&:name).map(&:downcase)

    duplicate_test_cases = []

    test_cases.each_with_index do |test_case, index|
      test_case_name = test_case.name.downcase
    if test_case_names[index + 1..- 1].include? test_case_name
    duplicate_test_cases << test_case
    puts "#{duplicate_test_cases.last.id} #{duplicate_test_cases.last.name}"
    test_case.destroy
    end
    end
  end
    #puts duplicate_test_cases.inspect
end

audit_remove_invalid_test_cases_of_cm_project