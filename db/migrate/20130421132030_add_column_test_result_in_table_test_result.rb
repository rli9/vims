class AddColumnTestResultInTableTestResult < ActiveRecord::Migration
  
  def up
    add_column("test_results", "result", :float, :default => nil)
  end
  
  def down
    remove_column("test_results", "result")
  end

end 