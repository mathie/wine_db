class CreateLwinIdentifiers < ActiveRecord::Migration
  def change
    create_table :lwin_identifiers do |t|
      t.integer :identifier, null: false
      t.integer :status, null: false
      t.date :identifier_updated_at, null: false
      t.uuid :wine_id

      t.timestamps null: false
    end

    add_foreign_key :lwin_identifiers, :wines,
      on_update: :restrict,
      on_delete: :restrict

    add_index :lwin_identifiers, :identifier, unique: true
  end
end