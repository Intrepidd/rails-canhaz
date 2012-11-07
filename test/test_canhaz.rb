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
        subject.can!(:whatever, foo)
    end

    assert_nothing_raised RuntimeError do
        subject.can!(:whatever, object)
    end

    assert_raise CanHaz::Exceptions::NotACanHazObject do
        subject.can?(:whatever, foo)
    end

    assert_nothing_raised RuntimeError do
        subject.can?(:whatever, object)
    end

  end

  def test_can
    subject = SubjectModel.new
    subject.save

    subject2 = SubjectModel.new
    subject2.save

    object = ObjectModel.new
    object.save

    subject2.can!(:foo, object)
    subject2.can!(:bar, object)

    assert subject.can?(:foo, object) == false
    assert subject.can?(:bar, object) == false

    assert object.accessible_by?(subject, :foo) == false
    assert object.accessible_by?(subject, :bar) == false

    assert subject.can!(:foo, object)
    assert subject.can!(:bar, object)

    assert subject.can!(:foo, object) == false
    assert subject.can!(:bar, object) == false

    assert subject.can?(:foo, object)
    assert subject.can?(:bar, object)

    assert object.accessible_by?(subject, :foo)
    assert object.accessible_by?(subject, :bar)

    assert subject.objects_with_permission(ObjectModel, :foo).count == 1
    assert subject.objects_with_permission(ObjectModel, :foo).first == object

    assert subject.objects_with_permission(ObjectModel, :bar).count == 1
    assert subject.objects_with_permission(ObjectModel, :bar).first == object

    assert subject.objects_with_permission(ObjectModel, :foobar).count == 0

  end

  def test_can_cannot
    subject = SubjectModel.new
    subject.save

    object = ObjectModel.new
    object.save

    assert subject.can?(:foo, object) == false
    assert subject.cannot!(:foo, object) == false

    subject.can!(:foo, object)
    subject.can!(:bar, object)

    assert subject.can?(:foo, object)
    assert subject.can?(:bar, object)

    assert subject.cannot!(:foo, object) == true

    assert subject.can?(:foo, object) == false
    assert subject.can?(:bar, object) == true
  end

  def test_subjects_from_object
    object = ObjectModel.new
    object.save

    s1 = SubjectModel.new
    s2 = SubjectModel.new
    s3 = SubjectModel.new

    s1.save
    s2.save
    s3.save

    s1.can!(:foo, object)
    s2.can!(:bar, object)
    s3.can!(:foo, object)

    foo = object.subjects_with_permission(SubjectModel, :foo)

    assert foo.include?(s1) == true
    assert foo.include?(s2) == false
    assert foo.include?(s3) == true

    s3.cannot!(:foo, object)

    foo = object.subjects_with_permission(SubjectModel, :foo)

    assert foo.include?(s1) == true
    assert foo.include?(s2) == false
    assert foo.include?(s3) == false

    bar = object.subjects_with_permission(SubjectModel, :bar)

    assert bar.include?(s1) == false
    assert bar.include?(s2) == true
    assert bar.include?(s3) == false

  end


  def test_drop_all
    subject = SubjectModel.new
    subject.save

    subject2 = SubjectModel.new
    subject2.save

    object1 = ObjectModel.new
    object1.save

    object2 = ObjectModel.new
    object2.save

    subject.can!(:foo, object1)
    subject.can!(:bar, object1)
    subject.can!(:foo, object2)
    subject.can!(:bar, object2)

    subject2.can!(:foo, object1)

    subject.can_do_nothing

    subject.reload

    assert subject.cannot?(:foo, object1)
    assert subject.cannot?(:bar, object1)
    assert subject.cannot?(:foo, object2)
    assert subject.cannot?(:bar, object2)

    assert subject2.reload.can?(:foo, object1)

  end

  def test_multiple
    s1 = SubjectModel.new
    s2 = SubjectModel.new

    o1 = ObjectModel.new
    o2 = ObjectModel.new

    s1.save
    s2.save
    o1.save
    o2.save

    s1.can!(:foo, o1)
    s1.can!(:foo, o2)
    s1.can!(:bar, o2)

    s2.can!(:bar, o1)
    s2.can!(:foo, o2)

    result = CanHazPermission.can?([s1, s2], :foo, [o1, o2])

    assert result[s1.id] == [o1, o2]
    assert result[s2.id] == [o2]

    result = CanHazPermission.can?([s1, s2], :bar, [o1, o2])

    assert result[s1.id] == [o2]
    assert result[s2.id] == [o1]

  end

  def test_destroy
    s = SubjectModel.new
    o = ObjectModel.new

    s.save
    o.save

    id = s.id

    s.can!(:foo, o)
    s.can!(:bar, o)

    s.destroy

    assert CanHazPermission.find_by_csubject_id(id).nil?

    s = SubjectModel.new
    o = ObjectModel.new

    s.save
    o.save

    id = o.id

    s.can!(:foo, o)
    s.can!(:bar, o)

    o.destroy

    assert CanHazPermission.find_by_cobject_id(id).nil?
  end

  def test_global_permissions

    s = SubjectModel.new
    s.save

    assert_equal false, s.can?(:foo)

    assert_equal true, s.can!(:foo)

    assert_equal true, s.can?(:foo)

    s.cannot!(:foo)

    assert_equal false, s.can?(:foo)
  end

end

