module CanHaz
  module ModelExtensions
    module All

      # Returns if a model is registered as a canhaz subject
      #
      # @return [Bool] Whether or not the model is a canhaz subject
      def canhaz_subject?
        false
      end

      # Returns if a model is registered as a canhaz object
      #
      # @return [Bool] Whether or not the model is a canhaz object
      def canhaz_object?
        false
      end

    end
  end
end
