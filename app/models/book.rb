class Book < ActiveRecord::Base
  has_and_belongs_to_many :users

  SIMILARITY_KEY = "similarity".freeze

  # Remove this for the moment and just focus on item-based similarity
  def self.recommended_for(user)
    raw_recommendations = user.books.flat_map(&:similar_books)
    Recommendation.squash(raw_recommendations)
  end

  # Returns the top n_results similar books, ordered by similarity.
  # Each book responds to a :similarity message with a numerical score
  def similar_books
    Book.find_by_sql(similar_query(book_id: id, n_results: 10))
  end

  private

  # TODO: parameterize on all table names and column names
  def similar_query(book_id:, n_results:)
    <<-SQL
      WITH similar_books AS (
        SELECT
          b2.book_id,
          (# (array_agg(DISTINCT b1.user_id) & array_agg(DISTINCT b2.user_id)))::float/
          (# (array_agg(DISTINCT b1.user_id) | array_agg(DISTINCT b2.user_id)))::float as similarity
        FROM books_users AS b1, books_users AS b2
        WHERE b1.book_id = #{book_id} and b2.book_id != #{book_id}
        GROUP BY b2.book_id
        ORDER BY similarity DESC
        LIMIT #{n_results}
      )
      SELECT books.*, similarity
      FROM similar_books
      JOIN books ON books.id = similar_books.book_id
      ORDER BY similarity DESC;
    SQL
  end
end
