class Voted
  include DataMapper::Resource

  property :id, Serial
  property :points, Float

  belongs_to :user
  belongs_to :food

end