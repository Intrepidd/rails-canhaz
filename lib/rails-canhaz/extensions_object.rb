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

      def canhaz_object?
        true
      end

    end
  end
end
