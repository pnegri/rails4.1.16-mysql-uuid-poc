class CreateTable < ActiveRecord::Migration
  def change
    create_table :tables, id: false do |t|
      t.uuid :id, primary_key: true
      t.string :name
      t.uuid :another_id
    end

    # add_index "tables", ["id"], name: "PRIMARY", using: :btree

    # execute "ALTER TABLE tables ADD PRIMARY KEY (id);"
  end
end
