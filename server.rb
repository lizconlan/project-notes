require 'haml'
require 'sass'
require 'sinatra'
require 'active_record'

require 'models/user'
require 'models/user_session'
require 'models/project'
require 'models/repository'

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
  current_user.reset_persistence_token
  current_user_session.destroy
  redirect '/'
end

get "/:project/?" do
  project_slug = params[:project]  
  @project = Project.find_by_name(Project.slug_to_name(project_slug))
  raise project_slug
  raise @project.inspect
  haml :project
end

get "/project/new/?" do
  haml :create_project
end

post "/project/new/?" do
  case params[:project]["name"]
    when nil, ""
      @error = "Project must have a name"
      haml :create_project
    when /$(project|login|logout|new)^/i
      @error = "Sorry <strong>#{params[:project]["name"]}</strong> can't be a project name"
      haml :create_project
    else
      if Project.find_by_name(params[:project]["name"])
        @error = "Hey, you already have one of those!"
        haml :create_project
      else
        project = Project.new(:name => params[:project]["name"], :description => params[:project]["description"])
        project.save
        redirect "/"
      end
  end 
end

get "/:project/edit/?" do
  project_slug = params[:project]
  @project = Project.find_by_name(Project.slug_to_name(project_slug))
  haml :edit_project
end

post "/:project/edit/?" do
  project_slug = params[:project]
  @project = Project.find_by_name(Project.slug_to_name(project_slug))
  @project.description = params[:edit]["description"]
  @project.save
  redirect "/#{@project.slug}"
end

get "/:project/add_repo/?" do
  project_slug = params[:project]
  @project = Project.find_by_name(Project.slug_to_name(project_slug))
  haml :add_repo  
end

post "/:project/add_repo/?" do
  project_slug = params[:project]
  @project = Project.find_by_name(Project.slug_to_name(project_slug))
  @repo = Repository.new
  @repo.name = params['edit']['name']
  @repo.github_url = params['edit']['url']
  @repo.notes = params['edit']['notes']
  @project.repositories << @repo
  @project.save
  redirect "/#{@project.slug}/edit"
end