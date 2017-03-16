class Category
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :picture, String

  has n, :food

end