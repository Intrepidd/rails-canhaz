require 'rubygems'
require 'active_record'
require 'active_support'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'test.sqlite3')
