class Food
  include DataMapper::Resource

  property :id, Serial
  property :name, String, required: true
  property :instruction, Text, required: true
  property :description, Text, required: true
  property :ingredients, Text, required: true

  belongs_to :user
  has n, :savedfood
  has n, :comment
  has n, :subcomment
  has n, :voted

end