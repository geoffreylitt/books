class CreateBooksUsers < ActiveRecord::Migration
  def change
    create_table :books_users do |t|
      t.integer :book_id
      t.integer :user_id
      t.timestamps
    end
  end
end
