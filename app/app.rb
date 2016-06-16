ENV['RACK_ENV'] ||= "development"
require 'sinatra/base'
require_relative 'data_mapper_setup'
require 'sinatra/flash'


class BookmarkManager < Sinatra::Base

  enable :sessions
  set :session_secret, 'super secret'

  register Sinatra::Flash

  get '/' do
    erb(:index)
  end

  get '/links' do
  	@links = Link.all
    @user = User.first(:id => session[:user_id])
  	erb(:'links/index')
  end

  get '/links/new' do
  	erb(:'links/new')
  end

  post '/links' do
  	#params[:url] and params[:title] both look at the name inputs in add.erb
  	link = Link.new(url: params[:url], title: params[:title])
    tags = params[:tags].split(", ").each do |tag|
      link.tags << Tag.first_or_create(name: tag)
    end

    link.save
  	redirect('/links')
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @name = params[:name]
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  post '/register' do
      user = User.create(name: params[:name], password: params[:password], email: params[:email], password_confirmation: params[:password_confirmation])
      case
      when user.save
        session[:user_id] = user.id
        redirect '/links'
      when params[:password] != params[:password_confirmation]
        flash.now[:notice] = 'Your passwords do not match! Please try again.'
        erb(:index)
      when
        flash.now[:notice] = 'Your email address is invalid. Please try again.'
        erb(:index)
      end
  end

  get '/sessions/new' do
    erb(:signin)
  end

  post '/sessions/authenticate' do
      user = User.authenticate(params[:email], params[:password])
      if user
        session[:user_id] = user.id
        redirect ('/links')
      else
        flash.now[:errors] = ['The email or password is incorrect']
        erb(:signin)
      end
    end


  run! if app_file == $0
end
