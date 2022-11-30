require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }


  def reset_both_tables
    seed_sql = File.read('spec/seeds/music_library.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end
  
  
  before(:each) do 
    reset_both_tables
  end



  context "POST /albums" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = post('/albums', title: 'Voyage', release_year: '2022', artist_id: '2')

      expect(response.status).to eq(200)
      expect(response.body).to eq("")

      response = get('/albums')
      expect(response.body).to include('Voyage')
    end
  end

  context "GET /albums/:id" do
    it "returns 200 ok and album info with given id" do

      response = get('/albums/1')

      # expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('Release year: 1989')
      expect(response.body).to include('Artist: Pixies')

    end
  end

  context "GET /albums" do
    it 'returns list of albums' do

      response = get('/albums')

      # expected_response = 'Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Albums</h1>')
      expect(response.body).to include('<a href="/albums/1">Doolittle</a>')
      expect(response.body).to include('Released: 1988')
      expect(response.body).to include('<a href="/albums/2">Surfer Rosa</a>')
      
    end

  end

  context "GET /artists" do

    it 'returns list of artists' do
   
      response = get('/artists')


      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Artists</h1>')
      expect(response.body).to include('<b>Pixies</b>')
      expect(response.body).to include('<b>Taylor Swift</b>')

      expect(response.body).to include('<a href="/artists/1"><b>Pixies</b></a>')
    end
  end

  context "GET /artists/:id" do
    it "returns 200 ok and artist info with given id" do

      response = get('/artists/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Pixies</h1>')
      expect(response.body).to include('Genre: Rock')

      expect(response.body).to include('Doolittle -')
      expect(response.body).to include('1989')
      
      expect(response.body).to include('Surfer Rosa -')
      expect(response.body).to include('1988')
    end
  end

  context "POST /artists" do
    it 'returns 200 OK' do
  
      response = post('/artists', name: 'Wild nothing', genre: 'indie')

      expect(response.status).to eq(200)
      expect(response.body).to eq("")

      response = get('/artists')
      expect(response.body).to include('nothing')
    end

  end

end
