module Mastermind
  
  class Game
    attr_accessor :board, :player, :numberOfTries, :counter, :numTurns
    
    def initialize(n=0)
      @numberOfTries = n < 4 ? numTries : n
      @board = Board.new
      @player = Player.new
      @counter = 0
      @numTurns = 0
    end
    
    def numTries
      getInput = nil
      while(getInput == nil)
        puts "How many tries would like to solve the code?"
        getInput = gets.chomp.to_i
        if(getInput <4 || getInput > 24)
          puts "Please input a number from 4 through 24\n"
          getInput = nil
        end
      end
      getInput
    end
    
    def over?
      if(@board.hasWon)
        return true
      elsif(@counter < @numberOfTries)
        @counter += 1
        return false
      end
      true
    end
    
    def nextTurnCmd
      getTurn = nil
      if(@numTurns == 0)
        puts @board.show(@numberOfTries, @numTurns)
      end
      while(getTurn == nil)
        puts "Enter 4 of the colors listed above." 
        getTurn = getPegsCmd
      end
      puts @board.show(@numberOfTries, @numTurns)
    end

    def nextTurn(input)
      if(input == "" || input == nil)
        return @board.show(@numberOfTries, @numTurns)
      end

      status = ""
      if(input.length !=4)
        status = "Input must be only 4 characters long\n\n"
      elsif(input.match?(/[ACDEFHIJKLMNQSUVXZ]+/i))
        status = "Does not match the available colors of the  pegs\n\n"
      else
        @numTurns += 1 + @board.makeMove(input)
      end
      status += @board.show(@numberOfTries, @numTurns)
    end

    def getPegsCmd
      input = gets.chomp
      if(input.length !=4)
        puts "Input must be only 4 characters long"
        return nil
      end
      if(input.upcase == "Q" || input.upcase == "QUIT" || input.upcase == "EXIT")
        puts " *** Game has been ended by the user *** "
        exit
      elsif(input.match?(/[ACDEFHIJKLMNQSUVXZ]+/i))
        puts "Does not match the available colors of the  pegs"
        return nil
      else
        @numTurns += 1 + @board.makeMove(input)
        return input
      end
    end

    def gameEnd
      endOut = "\n   ***   Game Over   ***\n"
      endOut += "\nYou #{@board.hasWon ? "Won!" : "Lost"}\n"
      endOut += "The code was:   #{@board.code}\n"
    end

  end
  
  class Player
    attr_accessor :guesses
    def initialize
      @guesses = []
    end
  end
  
  class Board
    attr_accessor :board, :guesses, :code, :colors, :hasWon
    
    def initialize
      @guesses = []
      @colors = ["R","Y","G","B","O","W","P","T"]
      @code = generateCode
      @hasWon = false
    end
    
    def show(num=nil, turns=nil)
      showOutput = ""
      num ||=12
      turns ||=0
      pegsLeft = num - turns
      system "clear"
      showOutput += "Colors:\n"
      showOutput += "R, Y, G, B, O, W, P, T\n\n\n"
      #showOutput += "CHEAT: #{code}\n\n\n"
      showOutput += "*=-==-==-==-=*--------*\n"
      pegsLeft.times { showOutput += "| o  o  o  o |  ....  |\n" }
      @guesses.reverse.each do |out|
        showOutput += "| #{out[0]}  #{out[1]}  #{out[2]}  #{out[3]} |  #{out[4]}#{out[5]}#{out[6]}#{out[7]}  |\n" 
      end
      showOutput += "*------------*--------*\n\n\n"
    end
    
    def makeMove(move=nil)
      tmp = ""
      if(move.nil?)
        return -1
      else
        tmp = guessPegs(move.upcase)
        @guesses << move.upcase + tmp
        isWinner(move)
      end
      return 0
    end
    
    def guessPegs(m=nil)
      _ret = "...."
      if(m == nil)
        return _ret
      end
      mPeg = m
      i = 0
      while(i < 4)
        if(code.include?(mPeg[i]))
          _ret.delete('.')
          _ret = 'o' + _ret
        end
        i += 1
      end
      mPeg = m
      i = 0
      while(i < 4)
        if(code[i] == (mPeg[i]))
          _ret = _ret.sub('o','0')
        end
        i += 1
      end
      _ret
    end
    
    def isWinner(m=nil)
      if(m.upcase == @code)
        @hasWon = true
        return true
      end
      false
    end
    
    private
    def generateCode
      @code = ""
      4.times { @code += @colors[rand(0..7)].upcase }
      @code
    end
    
  end
  
  #system "clear"
end

#mmGame = Mastermind
#game = mmGame::Game.new
#while(!game.over?)
#  game.nextTurnCmd
#end
#puts game.gameEnd



