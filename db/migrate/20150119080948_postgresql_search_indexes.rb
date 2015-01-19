class PostgresqlSearchIndexes < ActiveRecord::Migration
  def up
    add_search_vector :wines, :name
    add_search_vector :classifications, [:designation, :classification]
    add_search_vector :producers, :name
    add_search_vector :locations, :name
  end

  def down
    remove_search_vector :locations
    remove_search_vector :producers
    remove_search_vector :classifications
    remove_search_vector :wines
  end

  private
  def add_search_vector(table, columns)
    change_table table do |t|
      t.column :search_vector, :tsvector
    end

    add_index table, :search_vector, using: :gin

    execute <<-SQL.strip.gsub(/\s+/, ' ')
      CREATE TRIGGER #{table}_search_vector_update
        BEFORE INSERT OR UPDATE
        ON #{table}
        FOR EACH ROW EXECUTE PROCEDURE
          tsvector_update_trigger(
            search_vector,
            'pg_catalog.english',
            #{Array(columns).join(', ')}
          );
    SQL

    execute <<-SQL.strip.gsub(/\s+/, ' ')
      UPDATE #{table} SET updated_at = NOW();
    SQL
  end

  def remove_search_vector(table)
    execute <<-SQL.strip.gsub(/\s+/, ' ')
      DROP TRIGGER #{table}_search_vector_update
        ON #{table};
    SQL

    remove_index table, :search_vector

    change_table table do |t|
      t.remove :search_vector
    end
  end
end