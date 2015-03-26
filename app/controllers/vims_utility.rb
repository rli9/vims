require 'thread'

module VimsUtility
  class ParallelArray < Array
    def initialize
      @mutex = Mutex.new
      @index = -1
    end
    
    def next      
      @mutex.synchronize do
        @index = @index + 1
        return self[@index]
      end
    end
  end
  
  def parallel_batches(items, options = {})
    batch_size = options[:batch_size] || 1000
    
    data_sets = ParallelArray.new
    
    index = 0
    while true
      slice = items.slice(index, batch_size)
      break if slice.nil? || slice.empty?
      
      data_sets << slice
      index = index + batch_size    
    end
    workers = Array.new
    data_sets.each_index do |index|
      if index == data_sets.size - 1
        ActiveRecord::Base.connection_pool.with_connection do
          yield data_sets.next
        end
      else
        worker = Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            yield data_sets.next 
          end
        end
        
        workers << worker
      end
    end
    
    unless workers.empty?
      workers.each {|worker| worker.join} 
      ActiveRecord::Base.connection_pool.clear_stale_cached_connections!
    end
  end 
end
