class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :twitter_handle
      t.string :twitter_user_id

      t.timestamps
    end

    add_index(:users, :twitter_handle, :unique => true)
    add_index(:users, :twitter_user_id, :unique => true)
  end
end
