class CreateTable2 < ActiveRecord::Migration
  def change
    create_table :table2s, id: false do |t|
      t.uuid :id, primary_key: true
      t.uuid :table_id
    end
    
    # execute "ALTER TABLE table2s ADD PRIMARY KEY (id);"
  end
end
