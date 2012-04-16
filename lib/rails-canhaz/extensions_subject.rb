module CanHaz
  module ModelExtensions
    module Subject

      # Creates a permission on a given object
      #
      # @param permission [String, Symbol] The identifier of the permission
      # @param object [ActiveRecord::Base] The model on which the permission is effective
      # @return [Bool] True if the role was successfully created, false if it was already present
      def can(permission, object)
        raise Exceptions::NotACanHazObject unless object.canhaz_object?
        CanHazPermission.new({
          :csubject_id       => self.id,
          :csubject_type     => self.class.to_s,
          :cobject_type      => object.class.to_s,
          :cobject_id        => object.id,
          :permission_name  => permission
          }).save
      end

      # Checks if the subject has a given permission on a given object
      #
      # @param permission [String, Symbol] The identifier of the permission
      # @param object [ActiveRecord::Base] The model we are testing the permission on
      # @return [Bool] True if the user has the given permission, false otherwise
      def can?(permission, object)
        raise Exceptions::NotACanHazObject unless object.canhaz_object?
        CanHazPermission.find_permission(self, object, permission) != nil
      end

      # Removes a permission on a given object
      #
      # @param permission [String, Symbol] The identifier of the permission
      # @param object [ActiveRecord::Base] The model on which the permission is effective
      # @return [Bool] True if the role was successfully removed, false if it did not exist
      def cannot(permission, object)
        permission = CanHazPermission.find_permission(self, object, permission)
        return false if permission.nil?
        permission.destroy and return true
      end

      # Checks if the subject does not have a given permission on a given object
      # Acts as a proxy of !subject.can?(permission, object)
      #
      # @param permission [String, Symbol] The identifier of the permission
      # @param object [ActiveRecord::Base] The model we are testing the permission on
      # @return [Bool] True if the user has not the given permission, false otherwise
      def cannot?(permission, object)
        !self.can?(permission, object)
      end

      # Gets All objects that match a given type and permission
      #
      # @param type [Class] The type of the objects
      # @param permission [String, Symbol] The name of the permission
      # @return The macthing objects in an array
      def objects_with_permission(type, permission = nil)
        results = CanHazPermission.where('csubject_id = ? AND csubject_type = ?', self.id, self.class.to_s).where('cobject_type = ?', type.to_s).where('permission_name = ?', permission)

        ids = results.collect { |r| r.cobject_id }

        type.where('id IN (?)', ids)
      end

      def canhaz_subject?
        true
      end

    end
  end
end
