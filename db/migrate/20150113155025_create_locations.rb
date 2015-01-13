class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations, id: :uuid do |t|
      t.string :name, null: false
      t.uuid :parent_id

      t.timestamps null: false
    end

    add_index :locations, [:parent_id, :name], unique: true

    add_foreign_key :locations, :locations,
      column: :parent_id,
      on_delete: :restrict,
      on_update: :restrict
  end
end