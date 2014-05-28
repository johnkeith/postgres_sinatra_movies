require_relative 'helper_methods'
require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require 'pg'

def connect_db
  begin
    connection = PG.connect(dbname: 'movies')
    yield(connection)
  ensure
    connection.close
  end
end

get '/' do
  "Home"
end

get '/actors' do
  query = "SELECT actors.name, actors.id FROM actors ORDER BY actors.name;"
  @all_actors = connect_db {|conn| conn.exec(query)}.to_a

  haml :'actors/index'
end

get '/actors/:id' do
  actor_id = params[:id]
  query = "SELECT movies.title, actors.id, actors.name, cast_members.character FROM movies JOIN cast_members ON movies.id = cast_members.movie_id JOIN actors ON cast_members.actor_id = actors.id WHERE actors.id = $1 ORDER BY movies.title;"
  @actor_roles = connect_db {|conn| conn.exec_params(query, [actor_id])}.to_a
  
  haml :'actors/show'
end

get '/movies' do
  query = "SELECT movies.title, movies.year, movies.id, movies.rating, genres.name AS genre, studios.name AS studio FROM movies JOIN genres ON movies.genre_id = genres.id JOIN studios ON movies.studio_id = studios.id ORDER BY movies.title;"
  @all_movies = connect_db {|conn| conn.exec(query)}.to_a
  haml :'movies/index'
end

get '/movies/:id' do
  movie_id = params[:id]
  query = "SELECT movies.title, movies.year, movies.id, genres.name AS genre, studios.name AS studio, actors.name AS actor, actors.id AS actor_id, cast_members.character FROM movies JOIN studios ON movies.studio_id = studios.id JOIN genres ON movies.genre_id = genres.id JOIN cast_members ON cast_members.movie_id = movies.id JOIN actors ON cast_members.actor_id = actors.id WHERE movies.id = $1 ORDER BY movies.title;"
  @movie_info = connect_db {|conn| conn.exec_params(query, [movie_id])}.to_a

  haml :'movies/show'
end

