module CanHaz
  module Exceptions
    class NotACanHazSubject < StandardError; end
    class NotACanHazObject < StandardError; end
    class NotUniqueClasses < StandardError; end
  end
end
