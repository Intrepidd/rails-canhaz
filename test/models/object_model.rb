require 'active_record'
require 'rails-canhaz'

class ObjectModel < ActiveRecord::Base

  acts_as_canhaz_object

end
