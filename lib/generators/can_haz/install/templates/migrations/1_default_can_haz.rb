class DefaultCanHaz < ActiveRecord::Migration
  def self.up
    create_table :can_haz_permissions do |t|
      t.integer :csubject_id
      t.string :csubject_type

      t.integer :cobject_id
      t.string :cobject_type

      t.string :permission_name
    end

    add_index :can_haz_permissions, :csubject_id, :name => 'subject_id_ix'
    add_index :can_haz_permissions, :cobject_id, :name => 'object_id_ix'
  end

  def self.down
    drop_table :can_haz_permissions
  end
end
