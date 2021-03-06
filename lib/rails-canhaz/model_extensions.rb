require 'rails-canhaz/extensions_subject'
require 'rails-canhaz/extensions_object'
require 'rails-canhaz/extensions_all'

module CanHaz
  module ModelExtensions
    def self.included(base)
      base.send(:extend, ClassMethods)
      base.send(:include, CanHaz::ModelExtensions::All)
    end
  end

  module ClassMethods

    ##
    # Marks the current model as a canhaz object for authorizations
    #
    def acts_as_canhaz_object
      include CanHaz::ModelExtensions::Object
      extend CanHaz::ModelExtensions::Object::ClassMethods
      before_destroy :not_accessible # Removes permission before deleting the object
    end

    ##
    # Marks the current model as a canhaz subject for authorizations
    #
    def acts_as_canhaz_subject
      include CanHaz::ModelExtensions::Subject
      extend CanHaz::ModelExtensions::Subject::ClassMethods
      before_destroy :can_do_nothing # Removes permission before deleting the subject
    end

  end
end
