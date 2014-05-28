require_relative 'helper_methods'
require 'sinatra'
require 'haml'
require 'pg'

get '/actors' do
  haml :'actors/index'
end

get '/actors/:id' do
  haml :'actors/show'
end

get '/movies' do
  haml :'movies/index'
end

get '/movies/:id' do
  haml :'movies/show'
end
