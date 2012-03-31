module CanHaz
  module ModelExtensions
    def self.included(base)
      base.send(:extend, ClassMethods)
    end
  end

  module ClassMethods

    def CanHaz
      true
    end

  end
end
