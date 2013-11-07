class PollsTable < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title, unique: true
      t.integer :author_id

      t.timestamps
    end

    add_index :polls, :author_id
  end
end
