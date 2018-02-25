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
game = hangmanGame::Game.new

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
  guessLetter = params["guessLetter"]
  h_status = game.getPlayerInput(guessLetter)
  
  h_output  = game.display.gsub("\n","<br>")
  if(game.over?)
    if(game.guessCorrectly)
      win = "<h1>YOU WIN!</h1>"
    else
      win = "<h1>GAME OVER!</h1>"
    end
    h_status = win + "<p><a href=\'/hangman.erb\'>New Game!</a></p>"
    game = hangmanGame::Game.new
  end
  
  erb :hangman, :locals => { :h_output => h_output , :guessLetter => @@h_guess, :h_superfluous => h_status }
end

