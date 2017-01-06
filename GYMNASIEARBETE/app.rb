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

  get '/users/:username' do |username|

    if session[:user_id]
      @account = (User.first(id: session[:user_id])).username
    else
      redirect '/account'
    end

    @profile = User.all(username: username)
    erb :'user_erb/user_profile'

  end

  get '/konto/:message' do |message|

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

    erb :'food/food_results'

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

  post '/mat/rate/:id' do |food_id|

    rating = Rating.first(food_id: food_id)
    Rating.first(food_id: food_id).update(points: rating.points + params['rating'].to_f, votes: rating.votes + 1)

    p Voted.create(status: true, user_id: session[:user_id], food_id: food_id, points: params['rating'])
    
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
        User.create(username: params['username'], password: params['password'])
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

end