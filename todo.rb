# myapp.rb
require 'sinatra'
require 'securerandom'
require 'pry'

class Todo
  @@todos = []

  def self.all
    @@todos
  end

  def self.add(todo)
    @@todos.push(todo.merge(id: SecureRandom.uuid))
    @@todos.last
  end

  def self.find(id)
    @@todos.find { |t| t[:id] == id }
  end

  def self.index(id)
    @@todos.index { |t| t[:id] == id }
  end

  def self.update(todo)
    @@todos[@@todos.index(find(todo[:id]))] = todo

    todo
  end

  def self.delete(id)
    todo = find(id)
    @@todos.delete(todo)

    todo
  end
end

def render_page(page, locals: {})
  erb(page, locals: locals)
end

get '/' do
  render_page(:'todos/list', locals: { todos: Todo.all })
end

post '/todos' do
  new_todo = Todo.add(description: "New todo")

  erb(:'todos/item', locals: { todo: new_todo }, layout: false)
end

get '/todos/:id/edit' do
  todo = Todo.find(params[:id])

  erb(:'todos/edit', locals: { todo: todo }, layout: false)
end

delete '/todos/:id' do
  Todo.delete(params[:id])

  status 200
end

patch '/todos/:id' do
  todo = Todo.update(params.to_h.transform_keys(&:to_sym))

  erb(:'todos/item', locals: { todo: todo }, layout: false)
end