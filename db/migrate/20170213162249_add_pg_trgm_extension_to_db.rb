class AddPgTrgmExtensionToDb < ActiveRecord::Migration[5.0]
  def up
    # execute "CREATE EXTENSION IF NOT EXISTS pg_trgm;"
    # execute "CREATE EXTENSION IF NOT EXISTS btree_gin;"
    execute "CREATE INDEX watchables_search_idx ON watchables USING gin (title gin_trgm_ops);"
  end
  def down
    # execute "DROP EXTENSION IF EXISTS pg_trgm;"
    # execute "DROP EXTENSION IF EXISTS btree_gin;"
    execute "DROP INDEX watchables_search_idx;"
  end
end
