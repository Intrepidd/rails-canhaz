require 'rubygems'
require 'active_record'
require 'active_support'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'test.sqlite3')
ActiveSupport.on_load(:active_record) do
  try(:attr_accessible, nil)
end
