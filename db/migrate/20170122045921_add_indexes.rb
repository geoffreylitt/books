class AddIndexes < ActiveRecord::Migration
  def change
    add_index :books_users, [:book_id, :user_id], unique: true
    add_index :books_users, :user_id
  end
end
