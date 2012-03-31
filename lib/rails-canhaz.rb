require 'rails-canhaz/model_extensions'

if defined? ActiveRecord::Base
  ActiveRecord::Base.send(:include, CanHaz::ModelExtensions)
end
