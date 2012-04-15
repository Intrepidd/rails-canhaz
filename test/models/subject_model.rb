require 'active_record'
require 'rails-canhaz'

class SubjectModel < ActiveRecord::Base

  acts_as_canhaz_subject

end
