$:.unshift(File.dirname(__FILE__) + '/../lib')
                                     
require 'rubygems'             
require 'active_record'                     
require File.dirname(__FILE__) + '/../init'

ActiveRecord::Base.logger = Logger.new(nil)
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => '/tmp/jobs.sqlite')
ActiveRecord::Migration.verbose = false
          
def reset_db
  ActiveRecord::Schema.define do

    create_table :delayed_jobs, :force => true do |table|
      table.integer  :priority, :default => 0
      table.integer  :attempts, :default => 0
      table.text     :handler
      table.string   :last_error
      table.datetime :run_at   
      table.datetime :locked_until   
      table.string   :locked_by   
      table.timestamps    
    end

    create_table :stories, :force => true do |table|
      table.string :text
    end

  end
end                                         
    
# Purely useful for test cases...
class Story < ActiveRecord::Base          
  def tell; text; end
end