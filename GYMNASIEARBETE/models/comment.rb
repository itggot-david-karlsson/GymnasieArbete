class Comment
  include DataMapper::Resource

  property :id, Serial
  property :text, Text, required: true

  has n, :subcomment
  belongs_to :food
  belongs_to :user

end