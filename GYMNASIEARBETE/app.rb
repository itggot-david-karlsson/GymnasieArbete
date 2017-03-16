class App < Sinatra::Base
  enable :sessions

  get '/' do

    if session[:user_id]
      @account = (User.first(id: session[:user_id])).username
    else
      @account = "Logga in/Registrera"
    end

    erb :index

  end

  get '/konto/edit' do

    @account = (User.first(id: session[:user_id])).username
    @profile = User.first(id: session[:user_id])

    erb :'account/account_edit'

  end

  get '/konto/:profile' do |profile|

    if session[:user_id]
      @account = (User.first(id: session[:user_id])).username
    else
      redirect '/'
    end

    if profile == 'min_profil'
      @profile = User.first(id: session[:user_id])
      erb :'account/my_account'
    else
      @profile = User.first(id: profile)
      erb :'account/account'
    end

  end

  get '/inte_inloggad/:message' do |message|

    if session[:user_id]
      @account = (User.first(id: session[:user_id])).username
    else
      @account = "Logga in/Registrera"
    end

    if message == 'no_usr_pswrd'
      @message = "Inget användarnamn eller lösenord inskrivet."
    elsif message == 'no_username'
      @message = "Användarnamn kan inte lämnas blankt."
    elsif message == 'no_password'
      @message = "Lösenord kan inte lämnas blankt."
    elsif message == 'wrong'
      @message = "Fel användarnamn eller lösenord."
    elsif message == 'usr_exist'
      @message = "Användarnamnet finns redan."
    elsif message == 'p'
      @message = "Var vänlig logga in eller regristrera dig"
    else
    end

    erb :'account/nologin'

  end

  get '/register/:message' do |message|

    if message == 'no_usr_pswrd'
      @message = "No username or password input."
    elsif message == 'no_username'
      @message = "Username can't be blank."
    elsif message == 'no_password'
      @message = "Password can't be blank."
    elsif message == 'p'
      @message = "Please type in a username and password and press the register-button."
    elsif message == 'usr_exist'
      @message = "Username already taken by someone else."
    else
    end

    if session[:user_id]
      @account = (User.first(id: session[:user_id])).username
      redirect
    else
      @account = "Logga in/Registrera"
    end

    erb :'account/register'

  end

  get '/mat/sok' do

    if session[:user_id]
      @account = (User.first(id: session[:user_id])).username
    else
      @account = "Logga in/regristrera"
    end

    @results = Food.all(:name.like => params['search'])

    erb :'sorting/food_results'

  end

  get '/mat/sparade' do

    if session[:user_id]
      @account = (User.first(id: session[:user_id])).username
    else
      redirect '/'
    end

    @savedfood = Savedfood.all(user_id: session[:user_id])
    @food = Food.all

    erb :'food/saved_food'

  end

  get '/mat/skapade' do

    if session[:user_id]
      @account = (User.first(id: session[:user_id])).username
    else
      redirect '/'
    end

  @food = Food.all(user_id:session[:user_id])

  erb :'food/created_food'

  end

  get '/mat/skapa_ny' do

    if session[:user_id]
      @account = (User.first(id: session[:user_id])).username
    else
      redirect '/'
    end

    @categories = Category.all

    erb :'food/new_food'

  end

  get '/kategorier/alla_kategorier' do

    if session[:user_id]
      @account = (User.first(id: session[:user_id])).username
    else
      @account = "Logga in/regristrera"
    end

    @categories = Category.all

    erb :'sorting/categories'

  end

  get '/kategorier/:id' do |category_name|

    if session[:user_id]
      @account = (User.first(id: session[:user_id])).username
    else
      @account = "Logga in/regristrera"
    end

    @category = Category.first(name: category_name)
    @food = Food.all(category_id: @category.id)

    erb :'sorting/category_list'

  end

  post '/mat/rate/:id' do |food_id|

    rating = Rating.first(food_id: food_id)
    Rating.first(food_id: food_id).update(points: rating.points + params['rating'].to_f, votes: rating.votes + 1)

    Voted.create(user_id: session[:user_id], food_id: food_id, points: params['rating'].to_f)

    redirect "/mat/#{food_id}"

  end

  get '/mat/unrate/:id' do |food_id|

    vote = Voted.first(user_id: session[:user_id], food_id: food_id)
    rating = Rating.first(food_id: food_id)

    Rating.first(food_id: food_id).update(points: rating.points - vote.points, votes: rating.votes - 1)

    Voted.first(user_id: session[:user_id], food_id: food_id).destroy

    redirect "/mat/#{food_id}"

  end

  get '/mat/:id' do |food_id|

    if session[:user_id]
      @account = (User.first(id: session[:user_id])).username
    else
      @account = 'Logga in/Regristrera'
    end

    @users = User.all
    @food = Food.first(id: food_id)
    @comments = Comment.all(food_id: food_id)
    @subcomments = Subcomment.all(food_id: food_id)
    @rating = Rating.first(food_id: food_id)
    @voted = Voted.first(user_id: session[:user_id], food_id: food_id)

    rating = Rating.first(food_id: food_id)

    rate = rating.points/rating.votes
    puts rate
    puts rate
    puts rate
    if rate.to_s == "Infinity"
      @rate = "-"
    else
      @rate = rate.to_i
    end

    p @voted
    p @voted
    p @voted

    erb :'food/food_page'

  end

  post '/register_account' do

    if User.first(username: params['username'])
      redirect '/konto/usr_exist'
    else
      if params['username'] != '' && params['password'] != ''
        User.create(username: params['username'], password: params['password'], firstname: params['firstname'], lastname: params['lastname'], description: '')
        redirect '/konto/p'
      elsif params['username'] == ''
        if params['password'] == ''
          redirect '/konto/no_usr_pswrd'
        else
          redirect '/konto/no_username'
        end
      elsif params['password'] == ''
        redirect '/konto/no_password'
      end
    end

  end

  post '/login' do

    user = User.first(username: params['username'])
      if user && user.password == params['password']
        session[:user_id] = user.id
        redirect '/'
      else
        # redirect '/account'
        if params['username'] == ''
          if params['password'] == ''
            redirect '/konto/no_usr_pswrd'
          else
            redirect '/konto/no_username'
          end
        elsif params['password'] == ''
          redirect '/konto/no_password'
        else
          redirect '/konto/wrong'
        end
      end

    p "\n"*3
    p "#{params['username']}"
    p "\n"*3

  end

  post '/logout' do
    session[:user_id] = nil
    redirect '/'
  end

  post '/add/:id' do |food_id|

    Savedfood.create(user_id: session[:user_id], food_id: food_id)
    redirect '/mat/sparad_mat'

  end

  post '/create_food' do

    Food.create(name: params['name'], instruction: params['instruction'], user_id: session[:user_id], description: params['description'], category_id: params['category'], ingredients: params['ingredients'])

    redirect '/mat/skapade'

  end

  post '/upload' do

    directory_name = "public/img/uploads/test/#{session[:user_id]}/"
    Dir.mkdir(directory_name) unless File.exists?(directory_name)

    File.open("public/img/uploads/test/#{session[:user_id]}/" + params['file'][:filename], "w") do |f|
      f.write(params['file'][:tempfile].read)
    end

    File.rename("public/img/uploads/test/#{session[:user_id]}/" + params['file'][:filename], "public/img/uploads/test/#{session[:user_id]}/" + session[:user_id].to_s + ".jpg")

    if FastImage.size("public/img/uploads/test/#{session[:user_id]}/" + session[:user_id].to_s + ".jpg") == [300, 300] && FastImage.type("public/img/uploads/test/#{session[:user_id]}/" + session[:user_id].to_s + ".jpg") == :jpeg
      "Uploaded."
    else
      File.delete("public/img/uploads/test/#{session[:user_id]}/" + session[:user_id].to_s + ".jpg")
      "Too large resolution or not the correct filetype"
    end

  end

  post '/profile_pic/upload' do

    directory_name = "./public/img/uploads/profile/#{session[:user_id]}/"

    Dir.mkdir(directory_name) unless Dir.exists?(directory_name)

    File.open(directory_name + params['file'][:filename], "w") do |f|
      f.write(params['file'][:tempfile].read)
    end

    if FastImage.size(directory_name + params['file'][:filename]) == [300, 300] && FastImage.type(directory_name + params['file'][:filename]) == :jpeg
      File.rename(directory_name + params['file'][:filename], directory_name + session[:user_id].to_s + ".jpg")
      User.first(id: session[:user_id]).update(picture: "/img/uploads/profile/#{session[:user_id]}/#{session[:user_id]}.jpg")
      redirect "/konto/#{session[:user_id]}"
    else
      File.delete(directory_name + params['file'][:filename])
      "Too large resolution or not the correct filetype"
    end

  end

  post '/postcomment/:id' do |food_id|

    puts params['comment']
    puts session[:user_id]
    puts food_id

    Comment.create(text: params['comment'], food_id: food_id, user_id: session[:user_id])

  end

  post '/postsubcomment/:id' do |food_id|

    puts params['comment']
    puts session[:user_id]
    puts food_id

    Comment.create(text: params['comment'], food_id: food_id, user_id: session[:user_id])

  end


end