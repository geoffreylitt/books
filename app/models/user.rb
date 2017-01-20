class User < ActiveRecord::Base
  has_and_belongs_to_many :books

  # Returns an array of recommendations, each of which looks something like:
  #  {
  #    book123: {
  #     score: ___,
  #     reason: [
  #       book234, book345
  #     ]
  #   }
  # }
  def recommended_books
    Book.recommended_for(self) # puts all the recommendation at the item level
  end
end

class Recommendation
  attr_accessor :item, :score, :reason

  def initialize(item, score, reason)
    @item = item
    @score = score
    @reason = reason
  end

  # merges an array of recommendations with duplicate items into
  # an array of one recommendation per item, with merged metadata
  def self.squash(recommendations)
    recommendations.each_with_object({}) do |recommendation, hash|
      if hash[item]
        hash[item] = hash[item].merge(recommendation)
      else
        hash[item] = recommendation
      end
    end
  end

  def merge(other)
    raise ArgumentError unless self.item == other.item
    self.score += other.score
    self.reason << other.reason
  end
end
