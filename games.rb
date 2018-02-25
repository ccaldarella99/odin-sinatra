require 'sinatra'
load 'caesar-cipher.rb'
load 'hangman.rb'
#load 'Mastermind.rb'

#CAESAR CIPHER
@@c_words = "Write you message here!"
@@c_shift = 5

#HANGMAN
@@h_guess = ""
hangmanGame = Hangman

def getWords(w, s)
  @@c_words = w.to_s
  @@c_words = @@c_words.gsub("%20", " ")
  @@c_shift = s.to_i
  caesar = caesar_cipher(@@c_words, @@c_shift)
  c_output = "<h2>Sentence: #{@@c_words}</h2>"
  c_output += "<h2>Encoded: #{caesar}</h2>"
  c_output
end

get '/' do
	"<h1>PICK A GAME!</h1>
	<h2><a href=\"/caesar_cipher.erb\">Caesar Cipher</a></h2>
	<h2><a href=\"/mastermind.erb\">Mastermind</a></h2>
  <h2><a href=\"/hangman.erb\">Hangman</a></h2>"
end

get '/caesar_cipher.erb' do
  words = params["words"]
  shift = params["shift"]
  c_output = getWords(words, shift)
  erb :caesar_cipher, :locals => {:c_output => c_output, :words => @@c_words, :shift => @@c_shift}
end

get '/mastermind.erb' do
  m_output  = "<h2>Coming Soon!</h2>"
  erb :mastermind, :locals => { :m_output => m_output }
end

get '/hangman.erb' do
#  h_output  = "<h2>Coming Soon!</h2>"
#  h_output = hangmanGame.StartGame
  guessLetter = params["guessLetter"]
  
  game = hangmanGame::Game.new
  if(!game.over?)
    h_output  = game.display
  else
    h_output  = game.display
    h_output += OutputWinner(game.guessCorrectly)
  end
  
  
  erb :hangman, :locals => { :h_output => h_output , :guessLetter => guessLetter }#, :game => hangmanGame}
end

