module CanHaz
  module ModelExtensions
    module Subject

      # Creates a permission on a given object
      #
      # @param permission [String, Symbol] The identifier of the permission
      # @param object [ActiveRecord::Base, nil] The model on which the permission is effective
      #   Can be nil if it is a global permission that does not target an object
      # @return [Bool] True if the role was successfully created, false if it was already present
      def can!(permission, object = nil)
        raise Exceptions::NotACanHazObject unless (object.nil? || object.canhaz_object?)

        object_type = object.nil? ? nil : object.class.to_s
        object_id = object.nil? ? nil : object.id

        res = CanHazPermission.new({
          :csubject_id       => self.id,
          :csubject_type     => self.class.to_s,
          :cobject_type      => object_type,
          :cobject_id        => object_id,
          :permission_name  => permission
          }).save

        self.set_canhaz_cache(object, permission, true) if res
        res
      end

      # Checks if the subject has a given permission on a given object
      #
      # @param permission [String, Symbol] The identifier of the permission
      # @param object [ActiveRecord::Base, nil] The model we are testing the permission on
      #   Can be nil if it is a global permission that does not target an object
      # @return [Bool] True if the user has the given permission, false otherwise
      def can?(permission, object = nil)
        raise Exceptions::NotACanHazObject unless (object.nil? || object.canhaz_object?)

        cache = self.get_canhaz_cache(object, permission)
        return cache unless cache.nil?

        result = CanHazPermission.find_permission(self, object, permission) != nil
        self.set_canhaz_cache(object, permission,result) and return result
      end

      # Removes a permission on a given object
      #
      # @param permission [String, Symbol] The identifier of the permission
      # @param object [ActiveRecord::Base, nil] The model on which the permission is effective. Can be nil if it is a global permission that does not target an object
      # @return [Bool] True if the role was successfully removed, false if it did not exist
      def cannot!(permission, object = nil)
        perm = CanHazPermission.find_permission(self, object, permission)
        return false if perm.nil?
        perm.destroy and self.set_canhaz_cache(object, permission, false) and return true
      end

      # Checks if the subject does not have a given permission on a given object
      # Acts as a proxy of !subject.can?(permission, object)
      #
      # @param permission [String, Symbol] The identifier of the permission
      # @param object [ActiveRecord::Base] The model we are testing the permission on. Can be nil if it is a global permission that does not target an object
      # @return [Bool] True if the user has not the given permission, false otherwise
      def cannot?(permission, object = nil)
        !self.can?(permission, object)
      end

      # Removes all permissions on the current subject
      def can_do_nothing
        CanHazPermission.destroy_all(['csubject_id = ? AND csubject_type = ?', self.id, self.class.to_s])
        @__canhaz.clear
      end

      # Gets All objects that match a given type and permission
      #
      # @param type [Class] The type of the objects
      # @param permission [String, Symbol] The name of the permission
      # @return The macthing objects in an array
      def objects_with_permission(type, permission)
        type.joins("INNER JOIN can_haz_permissions ON can_haz_permissions.cobject_id = #{type.table_name}.id").where('cobject_type = ?', type.to_s).where('permission_name = ?', permission)
      end

      def canhaz_subject?
        true
      end

      protected

      # Sets a value in the cache
      #
      # @param [Object] object The canhaz object
      # @param [String, Symbol] permission the name of the permission
      # @param [Boolean] value The value for this permission
      def set_canhaz_cache(object, permission, value)
        id = object ? object.id : 0
        @__canhaz = {}
        @__canhaz[object.class.to_s] ||= {}
        @__canhaz[object.class.to_s][id] ||= {}
        @__canhaz[object.class.to_s][id][permission.to_s] = value
        true
      end

      # Gets a value from the cache
      #
      # @param [Object] object The canhaz object
      # @param [String, Symbol] permission the name of the permission
      # @return The value of this permission
      def get_canhaz_cache(object, permission)
        id = object ? object.id : 0
        @__canhaz[object.class.to_s][id][permission.to_s] rescue nil
      end

    end
  end
end
