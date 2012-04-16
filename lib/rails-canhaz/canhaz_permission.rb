require 'active_record'

class CanHazPermission < ActiveRecord::Base

  validates :cobject_id, :uniqueness => {:scope => [:permission_name, :csubject_id]}

  # Gets the permission row between two objects
  #
  # @param subject [ActiveRecord::Base] The subject
  # @param object [ActiveRecord::Base] The object
  # @param permission [String, Symbol] The permission identifier
  # @return [CanHazPermission, nil] The corresponding permission if found or nil
  def self.find_permission(subject, object, permission)
    raise NotACanHazSubject unless subject.canhaz_subject?
    raise NotACanHazObject unless object.canhaz_object?

    results = CanHazPermission.where(
      :csubject_id      => subject.id,
      :csubject_type    => subject.class.to_s,
      :cobject_id       => object.id,
      :cobject_type     => object.class.to_s,
      :permission_name  => permission
    )
    results.first
  end

end
