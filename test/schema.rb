
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'object_models'")
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'subject_models'")
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'canhaz_permissions'")
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'foo_models'")

ActiveRecord::Schema.define(:version => 0) do

  create_table :object_models do |t|

  end

  create_table :subject_models do |t|

  end

  create_table :canhaz_permissions do |t|
    t.integer :subject_id
    t.string :subject_type

    t.integer :object_id
    t.string :object_type

    t.string :permission_name
  end

  add_index :canhaz_permissions, :subject_id, :name => 'subject_id_ix'
  add_index :canhaz_permissions, :object_id, :name => 'object_id_ix'

  create_table :foo_models do |t|
  end

end
