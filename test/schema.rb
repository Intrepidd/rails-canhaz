
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'object_models'")
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'subject_models'")

ActiveRecord::Schema.define(:version => 0) do

  create_table :object_models do |t|

  end

  create_table :subject_models do |t|

  end

end
