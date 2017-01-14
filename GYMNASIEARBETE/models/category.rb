class Category
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  #property :picture, String <-- Skapa bilder senare

  has n, :food

end