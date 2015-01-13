class CreateWines < ActiveRecord::Migration
  def change
    create_table :wines, id: :uuid do |t|
      t.string :name, null: false
      t.integer :colour, null: false, default: 0
      t.integer :wine_type, null: false, default: 0
      t.uuid :producer_id
      t.uuid :location_id, null: false
      t.uuid :classification_id

      t.timestamps null: false
    end

    add_foreign_key :wines, :producers, on_delete: :restrict, on_update: :restrict
    add_foreign_key :wines, :locations, on_delete: :restrict, on_update: :restrict
    add_foreign_key :wines, :classifications, on_delete: :restrict, on_update: :restrict
  end
end