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
      end

      # Checks if the subject has a given permission on a given object
      #
      # @param permission [String, Symbol] The identifier of the permission
      # @param object [ActiveRecord::Base] The model we are testing the permission on
      # @return [Bool] True if the user has the given permission, false otherwise
      def can?(permission, object)
        raise Exceptions::NotACanHazObject unless object.canhaz_object?
      end

      def canhaz_subject?
        true
      end

    end
  end
end
