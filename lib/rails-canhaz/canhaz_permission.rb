require 'active_record'

class CanHazPermission < ActiveRecord::Base

  validates :cobject_id, :uniqueness => {:scope => [:permission_name, :csubject_id]}

end
