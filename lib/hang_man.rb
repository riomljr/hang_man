
word = File.readlines("dictionary.txt").select { |w| w.length[5..12]}.sample
size = word.length
display = " __ " * size


class Player
  attr_reader :name
  attr_reader :guess
  attr_reader :word

  def initialize (name)
    @name = name
    @guess
    @word = File.readlines("dictionary.txt").select { |w| w.length[5..12]}.sample.chomp
  end

  def player_input
    puts "Please enter a letter guess"
    begin
      input = gets.chomp
      raise if !input.match(/[[:alpha:]]/) || input.length > 1
    rescue
      puts "please only enter ONE alphabetical value"
      retry
    else
      @guess = input
    end

  end
end


class Game

  def process_player_guess


  end

  def display_game
    p = Player.new("Jeff")
    print @word = p.word
    @size = @word.length
  
    print "*********  HANGMAN  ************ \n\n"
    @display = ["_"] * @size

   # @size.times do 
    input = p.player_input
    indexes = (0 ... @size).find_all { |i| @word[i,1] == input }
    indexes.each {|number| @display[number] = input}

    p @display.join
        
  end

  
end

Game.new.display_game

