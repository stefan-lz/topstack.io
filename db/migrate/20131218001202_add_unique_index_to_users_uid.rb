class AddUniqueIndexToUsersUid < ActiveRecord::Migration
  def up
    add_index :users, :uid, :unique => true
  end
  def down
    remove_index :users, :uid
  end
end
