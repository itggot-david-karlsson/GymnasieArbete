class Subcomment
  include DataMapper::Resource

  property :id, Serial
  property :text, Text, required: true

  belongs_to :comment
  belongs_to :user

end