require 'init_tests'
require 'rails-canhaz'
require 'test/unit'
require 'models/object_model'
require 'models/subject_model'

load 'schema.rb'

class CanHazTest < Test::Unit::TestCase

  def test_methods
    assert ActiveRecord::Base.respond_to? :acts_as_canhaz_object
    assert ActiveRecord::Base.respond_to? :acts_as_canhaz_subject
  end

end
