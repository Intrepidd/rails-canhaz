require 'init_tests'
require 'rails-canhaz'
require 'test/unit'
require 'models/object_model'
require 'models/subject_model'
require 'models/foo_model'

load 'schema.rb'

class CanHazTest < Test::Unit::TestCase

  def test_methods
    assert ActiveRecord::Base.respond_to? :acts_as_canhaz_object
    assert ActiveRecord::Base.respond_to? :acts_as_canhaz_subject


    foo = FooModel.new

    assert foo.canhaz_object? == false
    assert foo.canhaz_subject? == false

    object = ObjectModel.new

    assert object.canhaz_object?
    assert object.canhaz_subject? == false

    subject = SubjectModel.new

    assert subject.canhaz_subject?
    assert subject.canhaz_object? == false

  end

  def test_exceptions
    foo = FooModel.new

    subject = SubjectModel.new

    object = ObjectModel.new

    assert_raise CanHaz::Exceptions::NotACanHazObject do
        subject.can(:whatever, foo)
    end

    assert_nothing_raised RuntimeError do
        subject.can(:whatever, object)
    end

  end

end
