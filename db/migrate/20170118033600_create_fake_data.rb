class CreateFakeData < ActiveRecord::Migration
  def fake_name
    ('a'..'z').to_a.shuffle[0,8].join
  end

  def change
    Book.delete_all
    User.delete_all

    puts "creating books..."
    1000.times do
      print "."
      Book.create(name: fake_name)
    end

    puts "creating users..."
    1000.times do
      print "."
      user = User.create(name: fake_name)
      num_books = (0..30).to_a.sample
      user.books = Book.all.sample(num_books)
    end
  end
end
