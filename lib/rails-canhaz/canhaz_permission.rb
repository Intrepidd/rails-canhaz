require 'active_record'

class CanHazPermission < ActiveRecord::Base

  attr_accessible :csubject_id, :csubject_type, :cobject_type, :cobject_id, :permission_name

  validates :cobject_id, :uniqueness => {:scope => [:permission_name, :csubject_id, :csubject_type, :cobject_type]}

  # Gets the permission row between two objects
  #
  # @param subject [ActiveRecord::Base] The subject
  # @param object [ActiveRecord::Base, nil] The object. Can be nil if it is a global permission that does not target an object
  # @param permission [String, Symbol] The permission identifier
  # @return [CanHazPermission, nil] The corresponding permission if found or nil
  def self.find_permission(subject, object = nil, permission)
    raise NotACanHazSubject unless subject.canhaz_subject?
    raise NotACanHazObject unless (object.nil? || object.canhaz_object?)

    object_type = object.nil? ? nil : object.class.to_s
    object_id = object.nil? ? nil : object.id

    results = CanHazPermission.where(
      :csubject_id      => subject.id,
      :csubject_type    => subject.class.to_s,
      :cobject_id       => object_id,
      :cobject_type     => object_type,
      :permission_name  => permission
    )
    results.first
  end

  # Gets the permissions for multiple subjects
  #
  # @param subjects [Array] an array of subjects
  # @param permission [Hash, String] The identifier of the permission
  # @param objects [Array] an array of objects
  # @return [Hash] A Hash of permissions, the key is the id of the object, the value is an array of objects that match
  def self.can?(subjects, permission, objects)

    return {} if subjects.size == 0 or objects.size == 0

    raise  NotUniqueClasses if subjects.group_by { |s| s.class }.size > 1
    raise  NotUniqueClasses if objects.group_by { |s| s.class }.size > 1

    subject_ids = subjects.collect { |s| s.id }
    object_ids = objects.collect{ |o| o.id }

    results = CanHazPermission.where(
      [
        'csubject_id IN (?) AND cobject_id IN(?) AND csubject_type = ? AND cobject_type = ? AND permission_name = ?',
        subject_ids,
        object_ids,
        subjects.first.class.to_s,
        objects.first.class.to_s,
        permission
      ]
    )

    h = {}

    subjects.each do |subject|
      # Get the ids of the objects that matched
      matching = results.find_all { |result| result.csubject_id == subject.id}.collect { |c| c.cobject_id }
      h[subject.id] = objects.find_all { |object| matching.include? object.id }
    end

    h

  end

end
