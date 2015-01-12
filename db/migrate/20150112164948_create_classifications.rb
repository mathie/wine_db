class CreateClassifications < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :classifications, id: :uuid do |t|
      t.string :designation, null: false
      t.string :classification

      t.timestamps null: false
    end

    add_index :classifications, [:designation, :classification], unique: true
  end
end