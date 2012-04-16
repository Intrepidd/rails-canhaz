require 'rails-canhaz/model_extensions'
require 'rails-canhaz/canhaz_permission'

if defined? ActiveRecord::Base
  ActiveRecord::Base.send(:include, CanHaz::ModelExtensions)
end
