require 'yaml'

class Player
  attr_accessor :word, :size, :display, :tries, :guess
  def initialize (name)
    @name = name
    @word = File.readlines("dictionary.txt").select { |w| w.length > 5 && w.length < 12}.sample
    @size = @word.length
    @display = ["_"] * @size
    @tries = 7
    @guess
  end
end

class Hangman

  def player_input(player)
    puts "Please enter a letter guess"
    begin
      input = gets.chomp
      raise if !input.match(/[[:alpha:]]/) || input.length > 1
    rescue
      puts "please only enter ONE alphabetical value"
      retry
    else
      player.guess = input
    end
  end

  def player_guess_correct(correct)
    puts "Nice! You guessed correct"
    p correct.join
  end

  def player_incorrect_guess(amount)
    puts "Wrong Guess! You have #{amount} tries left"
  end

  def save_game()
    yaml = YAML::dump(characters)
    game_file = GameFile.new("/my_game/saved.yaml")
    game_file.write(yaml)
  end

  def ask_player_to_save
    option = ["yes", "no"]
    puts "Would you like to save the game?"
    begin
      input = get.chomp.downcase
      raise if !option.include?(input)
    rescue
      "please only type yes or no"
      retry
    else
      #serialize?
    end
  end

  def game_cycle(player)
    @display = player.display
    @tries = player.tries
    @size = player.size
    @word = player.word

    loop do 
      if @tries == 0 
        puts "Sorry. You've Lost!"
        break
      end
      input = player_input(player)
      indexes = (0 ... @size).find_all { |i| @word[i,1] == input }
      if indexes.length > 0
        indexes.each {|number| @display[number] = input}
        player_guess_correct(@display)
        if @display.join == player.word
          print "You Won!"
          break
        end
      else
        player_incorrect_guess(@tries)
        @tries -= 1
      end
    end 
  end

  def play_game(player)
    puts "*********  HANGMAN  ************ "
    puts "I pick a word and you have to try to guess it by guessing each letter."
    p player.display.join
    game_cycle(player)
  end
end

player = Player.new("Jeff")
Hangman.new.play_game(player)


