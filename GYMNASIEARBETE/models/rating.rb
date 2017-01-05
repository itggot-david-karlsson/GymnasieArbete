class Rating
  include DataMapper::Resource

  property :id, Serial
  property :points, Float
  property :votes, Integer

  belongs_to :food

end