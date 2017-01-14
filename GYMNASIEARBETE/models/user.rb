class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String, required: true, unique: true
  property :password, BCryptHash, required: true
  property :firstname, String
  property :lastname, String
  property :description, Text
  property :picture, String

  has n, :savedfood
  has n, :food
  has n, :subcomment
  has n, :comment
  has n, :voted

end