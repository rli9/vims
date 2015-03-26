namespace :thin do
  namespace :cluster do    desc 'Start thin cluster'
    task :start => :environment do
      `cd #{Rails.root}`
      port_range = ENV['RAILS_ENV'] == 'development' ? 3 : 8
      (ENV['SIZE'] ? ENV['SIZE'].to_i : 4).times do |i|
        Thread.new do
          port = ENV['PORT'] ? ENV['PORT'].to_i + i : ("#{port_range}%03d" % i)
          str  = "thin start -d -p#{port}"
          str += " -e" + ENV['RAILS_ENV']
          puts str
          puts "Starting server on port #{port}..."
          `#{str}`
        end
      end
    end
  end
end