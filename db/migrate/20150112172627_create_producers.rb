class CreateProducers < ActiveRecord::Migration
  def change
    create_table :producers, id: :uuid do |t|
      t.string :name, null: false

      t.timestamps null: false
    end

    add_index :producers, :name, unique: true
  end
end