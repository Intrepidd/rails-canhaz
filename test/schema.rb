
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'object_models'")
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'subject_models'")
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'can_haz_permissions'")
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'foo_models'")

ActiveRecord::Schema.define(:version => 0) do

  create_table :object_models do |t|

  end

  create_table :subject_models do |t|

  end

  create_table :can_haz_permissions do |t|
    t.integer :csubject_id
    t.string :csubject_type

    t.integer :cobject_id
    t.string :cobject_type

    t.string :permission_name
  end

  add_index :can_haz_permissions, :csubject_id, :name => 'subject_id_ix'
  add_index :can_haz_permissions, :cobject_id, :name => 'object_id_ix'

  create_table :foo_models do |t|
  end

end
