class Voted
  include DataMapper::Resource

  property :id, Serial
  property :status, Boolean
  property :points, Float

  belongs_to :user
  belongs_to :food

end