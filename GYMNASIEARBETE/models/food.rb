class Food
  include DataMapper::Resource

  property :id, Serial
  property :name, String, required: true
  property :instruction, Text, required: true
  property :description, Text, required: true

  has n, :savedfood
  has n, :comment
  has n, :subcomment
  has n, :voted

end