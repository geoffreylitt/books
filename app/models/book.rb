class Book < ActiveRecord::Base
  has_and_belongs_to_many :users

  recommend_based_on {
    users: 1.0,
    tags: 2.0
  }

  def self.recommended_for(user)
    raw_recommendations = user.books.flat_map(&:similar_items)
    Recommendation.squash(raw_recommendations)
  end

  def similar_items
    # # Jaccard similarity
    # SELECT
    #   (# (array_agg(DISTINCT b1.user_id) & array_agg(DISTINCT b2.user_id)))::numeric /
    #   (# (array_agg(DISTINCT b1.user_id) | array_agg(DISTINCT b2.user_id)))::numeric as similarity
    # FROM books_users AS b1, books_users AS b2
    # WHERE b1.book_id = 1002 AND b2.book_id = 1003;
  end
end
