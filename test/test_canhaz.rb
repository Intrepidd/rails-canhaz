require 'test/unit'
require 'active_record'
require 'rails-canhaz'
require 'models/object_model'
require 'models/subject_model'

class CanHazTest < Test::Unit::TestCase

  def test_methods
    assert ActiveRecord::Base.respond_to? :acts_as_canhaz_object
    assert ActiveRecord::Base.respond_to? :acts_as_canhaz_subject
  end

end
