module CanHaz
  module ModelExtensions
    module Object

      # Checks if the model is accessible by a given subject and a given permission
      # This is a proxy to subject.can?(permission, subject)
      #
      # @param subject [ActiveRecord::Base] The subject we are testing
      # @param permission [String, Symbol] The permission we want to test the subject on
      # @return [Boolean] True if the subject has the permission on this object, false otherwise
      def accessible_by?(subject, permission)
        subject.can?(permission, self)
      end

      # Gets the subjects that have the corresponding permission and type on this model
      #
      # @param type [Class] The type of the subjects we're looking for
      # @param permission [String, Symbol] The permission
      def subjects_with_permission(type, permission)
        results = CanHazPermission.where('cobject_id = ? AND cobject_type = ?', self.id, self.class.to_s).where('csubject_type = ?', type.to_s).where('permission_name = ?', permission)

        ids = results.collect { |r| r.csubject_id }

        type.where('id IN (?)', ids)
      end

      def canhaz_object?
        true
      end

    end
  end
end
