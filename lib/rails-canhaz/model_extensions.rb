require 'rails-canhaz/extensions_subject'
require 'rails-canhaz/extensions_object'

module CanHaz
  module ModelExtensions
    def self.included(base)
      base.send(:extend, ClassMethods)
    end
  end

  module ClassMethods

    ##
    # Marks the current model as a canhaz object for authorizations
    #
    def acts_as_canhaz_object
      include CanHaz::ModelExtensions::Object
    end

    ##
    # Marks the current model as a canhaz subject for authorizations
    #
    def acts_as_canhaz_subject
      include CanHaz::ModelExtensions::Subject
    end

  end
end
