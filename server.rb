require 'haml'
require 'sass'
require 'sinatra'
require 'active_record'

require 'models/user'
require 'models/user_session'
require 'models/project'

require 'authlogic' 

configure do
  enable :sessions
  dbconfig = YAML::load(File.open 'config/database.yml')[ Sinatra::Application.environment.to_s ]
  ActiveRecord::Base.establish_connection(dbconfig)
end

# Work around a bug in authlogic.  See:
#     http://github.com/binarylogic/authlogic/issuesearch?state=open&q=remote_ip#issue/80
class Sinatra::Request
  alias remote_ip ip
end

# Rails style nested params
before do  
  modules_to_load = [
    Authlogic::ActsAsAuthentic::SingleAccessToken::Methods::InstanceMethods,
    Authlogic::ActsAsAuthentic::SingleAccessToken::Methods,
    Authlogic::ActsAsAuthentic::SessionMaintenance::Methods,
    Authlogic::ActsAsAuthentic::PersistenceToken::Methods::InstanceMethods,
    Authlogic::ActsAsAuthentic::PersistenceToken::Methods,
    Authlogic::ActsAsAuthentic::PerishableToken::Methods::InstanceMethods,
    Authlogic::ActsAsAuthentic::PerishableToken::Methods,
    Authlogic::ActsAsAuthentic::Password::Methods::InstanceMethods,
    Authlogic::ActsAsAuthentic::Password::Methods,
    Authlogic::ActsAsAuthentic::Password::Callbacks,
    Authlogic::ActsAsAuthentic::MagicColumns::Methods,
    Authlogic::ActsAsAuthentic::Login::Methods,
    Authlogic::ActsAsAuthentic::LoggedInStatus::Methods::InstanceMethods,
    Authlogic::ActsAsAuthentic::LoggedInStatus::Methods,
    Authlogic::ActsAsAuthentic::Email::Methods
  ].reject{ |m| User.included_modules.include? m }
  User.send :include, *modules_to_load
  
  new_params = {}
  params.each_pair do |full_key, value|
    this_param = new_params
    split_keys = full_key.split(/\]\[|\]|\[/)
    split_keys.each_index do |index|
      break if split_keys.length == index + 1
      this_param[split_keys[index]] ||= {}
      this_param = this_param[split_keys[index]]
   end
   this_param[split_keys.last] = value
  end
  request.params.replace new_params
end

helpers do
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
end

get "/favicon.ico" do
  status 404
end

get "/styles.css" do
  content_type 'text/css', :charset => 'utf-8'
  sass :styles
end

get "/" do
  @projects = Project.all
  haml :index
end

get "/login/?" do
  haml :login
end

post "/login/?" do
  @user_session = UserSession.new(params[:user])
  if @user_session.save
    session[:message] = ""
    redirect '/'
  else
    session[:message] = "Username and password combination not recognised"
    haml :login
  end
end

get "/logout/?" do
  current_user_session.destroy
  response.set_cookie("rack.session", { :expires => Time.now - 36000})
  redirect '/'
end

get "/account/create/?" do
end

get "/account/:name/?" do
end

get "/account/:name/destroy/?" do
end

get "/:project/?" do
end

get "/:project/edit/?" do
end