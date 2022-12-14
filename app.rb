# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do

   repo = AlbumRepository.new
   @albums = repo.all

  #  response = albums.map  do |album|
  #   album.title
  #  end.join(', ')

  #  response
  erb(:all_albums)

  end

  get '/albums/new' do

    erb(:new_album)

  end

  post '/albums' do
    if params[:title] == nil || params[:release_year] == nil || params[:artist_id] == nil
      status 400
      return ''
    end


    @album_name = params[:title]

    repo = AlbumRepository.new
    album = Album.new
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]
    
    repo.create(album)

  
    erb(:album_created)
  end

  get '/artists/new' do

    erb(:new_artist)

  end

  post '/artists' do
    @artist_name = params[:name]

    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)

    erb(:artist_created)
  end

  get '/albums/:id' do

    repo = AlbumRepository.new
    artist_repository = ArtistRepository.new

    @album = repo.find(params[:id])
    @artist = artist_repository.find(@album.artist_id)

    erb(:albums)

  end


  get '/artists' do

    repo = ArtistRepository.new
    @artists = repo.all

    # response = artists.map do |artist|

    #   artist.name
    # end.join(', ')

    # response
    erb(:all_artists)
  end


  get '/artists/:id' do

    repo = ArtistRepository.new
    album_repo = AlbumRepository.new

    @artist = repo.find(params[:id])

    @albums = []

    all_albums = album_repo.all

    all_albums.each do |album|
      if album.artist_id == params[:id].to_i
        @albums << album
      end
    end

    erb(:artists)

  end


  
end