class Seeder

  def self.seed!
    self.users
    self.categories
    self.foods
    self.savedfoods
    self.comments
    self.subcomments
    self.ratings
    self.voted
  end

  def self.users
    User.create(username: 'grill', password: 'korv', firstname: 'Daniel', lastname: 'Berg', description: 'Gillar diverse korvar', picture: '/img/uploads/test/Orange-Whole-&-Split.jpg')
    User.create(username: 'tester', password: '111', firstname: 'Test', lastname: 'Grabben', description: 'Testar saker', picture: '/img/uploads/test/Orange-Whole-&-Split.jpg')
    User.create(username: 'david', password: 'xxx', firstname: 'David', lastname: 'Karlsson', description: 'Jag är cool.', picture: '/img/uploads/test/Orange-Whole-&-Split.jpg')
  end

  def self.categories
    Category.create(name: 'Kött', picture: '/img/categories/Kott_test.png')
    Category.create(name: 'Grönsaker', picture: '/img/categories/Gronsaker_test.png')
  end

  def self.foods
    Food.create(name: 'KKK', instruction: 'Ku Klux Klan', user_id: 1, description: "aja baja", category_id: 1, ingredients: 'choklad')
    Food.create(name: 'XXX', instruction: 'Xu Xlux Xlan', user_id: 3, description: "niiiiiice", category_id: 1, ingredients: 'choklad mm')
    Food.create(name: 'ZZZ', instruction: 'Zu Zlux Zlan', user_id: 2, description: "shiiiiize", category_id: 2, ingredients: 'choklad o sånt')
  end

  def self.savedfoods
    Savedfood.create(user_id: 1, food_id: 1)
    Savedfood.create(user_id: 2, food_id: 2)
    Savedfood.create(user_id: 3, food_id: 1)
    Savedfood.create(user_id: 3, food_id: 2)
    Savedfood.create(user_id: 3, food_id: 3)
  end

  def self.comments
    Comment.create(text: "ablalalalala", food_id: 1, user_id: 1)
    Comment.create(text: "shit shit shit", food_id: 1, user_id: 2)
    Comment.create(text: "Shize", food_id: 2, user_id: 1)
    Comment.create(text: "Goes Well With Crack", food_id: 3, user_id:3)
  end

  def self.subcomments
    Subcomment.create(text: "Aa visst", comment_id: 1, user_id: 1)
    Subcomment.create(text: "mhmmm", comment_id: 1, user_id: 2)
    Subcomment.create(text: "I like trains", comment_id: 1, user_id: 3)
    Subcomment.create(text: "lalalala", comment_id: 2, user_id: 2)
    Subcomment.create(text: "yup brah", comment_id: 3, user_id: 3)
  end

  def self.ratings
    Rating.create(points: 15, votes: 3, food_id: 1)
    Rating.create(points: 0, votes: 0, food_id: 2)
    Rating.create(points: 2, votes: 1, food_id: 3)
  end

  def self.voted
    Voted.create(user_id: 1, food_id: 1, points: 5)
    Voted.create(user_id: 2, food_id: 1, points: 5)
    Voted.create(user_id: 3, food_id: 1, points: 5)
    Voted.create(user_id: 1, food_id: 2, points: 2)
    Voted.create(user_id: 1, food_id: 3, points: 2)
  end

end