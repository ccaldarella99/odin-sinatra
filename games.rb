require 'sinatra'
load 'caesar-cipher.rb'
load 'hangman.rb'
load 'Mastermind.rb'

#CAESAR CIPHER
@@c_words = "Write you message here!"
@@c_shift = 5

#HANGMAN
@@h_guess = ""
hangmanGame = Hangman
game = hangmanGame::Game.new

#MASTERMIND
m_maxTurns = 4
mmGame = Mastermind
m_game = mmGame::Game.new(m_maxTurns)
@@m_tries = 0

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
  m_guess = params["m_guess"]
  m_output = m_game.nextTurn(m_guess).gsub("\n","<br>")
  
  if(m_game.over?)
    m_status = m_game.gameEnd.gsub("\n","<br>") + "<p><a href=\'/mastermind.erb\'>New Game!</a></p>"
    m_game = mmGame::Game.new(m_maxTurns)
  end
  
  erb :mastermind, :locals => { :m_output => m_output, :m_guess => m_guess, :m_status => m_status }
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

