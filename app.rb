# app.rb
require 'sinatra'
require 'securerandom'
require 'pry'
require 'sinatra/activerecord'

require './models/todo'

def hx_trigger(event, target)
  response['HX-Trigger'] = "{ \"#{event}\": { \"target\": \"#{target}\" } }"
end

get '/' do
  erb(:'todos/list', locals: { todos: Todo.order(id: :asc) })
end

post '/todos' do
  new_todo = Todo.create(description: "")
  hx_trigger('reloadCount', '#todoCount')
  erb(:'todos/edit', locals: { todo: new_todo }, layout: false)
end

get '/todos/:id/edit' do
  todo = Todo.find(params[:id])
  erb(:'todos/edit', locals: { todo: todo }, layout: false)
end

get '/todos/count' do
  erb(
    :'todos/count',
    locals: {
      count: Todo.count,
      done_count: Todo.where(done: true).count
    },
    layout: false
  )
end

delete '/todos/:id' do
  Todo.destroy(params[:id])
  hx_trigger('reloadCount', '#todoCount')
  status 200
end

patch '/todos/:id' do
  todo = Todo.find(params[:id])
  todo.update(params)
  erb(:'todos/item', locals: { todo: todo }, layout: false)
end

post '/todos/:id/toggle' do
  todo = Todo.find(params[:id])
  todo.update(done: !todo.done)
  hx_trigger('reloadCount', '#todoCount')
  erb(:'todos/item', locals: { todo: todo }, layout: false)
end