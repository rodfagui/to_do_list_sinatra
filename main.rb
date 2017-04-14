require 'sinatra'
require 'dm-core'
require 'dm-migrations'

class Task
  include DataMapper::Resource
  property :id, Serial
  property :content, Text, :required => true
  property :complete, Boolean, :required => true, :default => false
  property :created_at, DateTime
  property :updated_at, DateTime
end

configure do
  DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3://#{Dir.pwd}/tareas.db"))
  DataMapper.finalize.auto_upgrade!
end

get '/' do
  @tasks = Task.all :order => :id.desc
  @title = 'All Tasks'
  erb :home
end

post '/' do
  t = Task.new
  t.content = params[:content]
  t.created_at = Time.now
  t.updated_at = Time.now
  t.save
  redirect '/'
end

get '/list/complete_tasks' do
	@tasks = Task.all :order => :id.desc
	@title = 'All Complete Tasks'
  erb :complete_tasks
end

get '/list/incomplete_tasks' do
	@tasks = Task.all :order => :id.desc
	@title = 'All Incomplete Tasks'
  erb :incomplete_tasks
end

get '/:id' do
  @task = Task.get params[:id]
  @title = "Edit task ##{params[:id]}"
  erb :edit
end

put '/:id' do
  t = Task.get params[:id]
  t.content = params[:content]
  t.complete = params[:complete] ? 1 : 0
  t.updated_at = Time.now
  t.save
  redirect '/'
end

get '/:id/delete' do
  @task = Task.get params[:id]
  @title = "Confirm deletion of task ##{params[:id]}"
  erb :delete
end

delete '/:id' do
  t = Task.get params[:id]
  t.destroy
  redirect '/'
end

get '/:id/complete' do
  t = Task.get params[:id]
  t.complete = t.complete ? 0 : 1 # flip it
  t.updated_at = Time.now
  t.save
  redirect '/'
end