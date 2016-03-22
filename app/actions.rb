# Homepage (Root path)
helpers do
  def get_songs
    @songs = Song.all.sort_by do |song| 
      song.votes.where(up: true).length - song.votes.where(up: false).length
    end.reverse
  end
  def get_user_vote(user, song)
    return if user.nil?
    vote = Vote.find_by(user_id: user.id, song_id: song.id)
    return if vote.nil?
    if vote.up
      "upvote"
    else
      "downvote"
    end
  end
end


enable :sessions

get '/' do
  erb :index
end

get '/songs' do
  get_songs
  erb :'songs/index'
end

get '/songs/new' do
  if session["user"]
    @song = Song.new
    erb :'songs/new'
  else
    redirect 'users/new'
  end
end

post '/songs' do
  @song = Song.new(
    title: params[:title],
    author: params[:author],
    url: params[:url],
    user_id: session["user"].id
  )
  if @song.save
    redirect '/songs'
  else 
    erb :'messages/new'
  end
end

get '/songs/:id' do
  @song = Song.find(params[:id])
  erb :'songs/show'
end

get '/users' do
  @users = User.all
  erb :'users/index'
end

get '/users/new' do
  @user = User.new
  erb :'users/new'
end

post '/users' do
  @user = User.new(
    name: params[:name],
    password: params[:password],
  )
  if @user.save
    redirect '/songs'
  else 
    erb :'users/new'
  end
end

post '/login' do
  @login_message = ""
  @user = User.find_by(name: params[:name], password: params[:password])
  if @user
    session["user"] = @user
    redirect '/users'
  else
    @login_message = "Incorrent username or password"
    get_songs
    erb :'songs/index'
  end
end

post '/logout' do
  session["user"] = nil
  redirect '/songs'
end

get '/users/:id' do
  @user = User.find(params[:id])
  erb :'users/show'
end

post '/upvote/:id' do
  @song = Song.find(params[:id])
  if @song.votes.where(song_id: @song.id, user_id: session["user"].id).empty?
    @song.votes.create(up: true, user_id: session["user"].id)
    @song.save
  end
  redirect '/songs'
end

post '/downvote/:id' do
  @song = Song.find(params[:id])
  if @song.votes.where(song_id: @song.id, user_id: session["user"].id).empty?
    @song.votes.create(up: false, user_id: session["user"].id)
    @song.save
  end
  redirect '/songs'
end