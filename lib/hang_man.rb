require 'yaml'

class Player
  attr_accessor :word, :size, :display, :tries, :guess
  def initialize (name)
    @name = name
    @word = File.readlines("dictionary.txt").select { |w| w.length > 5 && w.length < 12}.sample.chomp
    @size = @word.length
    @display = ["_"] * @size
    @tries = 7
    @guess
  end
end

class Game

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

  def save_game(characters)
    yam = YAML::dump(characters)
    dirname = "my_game"
    Dir.mkdir(dirname) unless File.exists?(dirname)
    File.open("#{dirname}/saved.yaml", 'w'){|f| f.write(yam)}
  end

  def ask_player_to_save(player)
    puts "Would you like to save the game?"
    input = gets.chomp
    if input == 'yes'
      save_game(player)
    end
  end

  def game_cycle(player)
    @display = player.display
    @tries = player.tries
    @size = player.size
    @word = player.word

    loop do 
      ask_player_to_save(player)
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
    p player.display.join
    game_cycle(player)
  end
end

def load_game
  data = File.open("my_game/saved.yaml", "r"){|file| file.read}
  player = YAML::load(data)
  Game.new.play_game(player)
 
end

def initiate 
  if File.exist?("my_game/saved.yaml")
    load_game()
  else
    puts "                 *********  HANGMAN  ************ "
    puts "What is your Name?"
    input = gets.chomp
    puts "Hello, #{input} I'll pick a word and you have to try to guess it letter by letter."
    player = Player.new(input)
    Game.new.play_game(player)
  end
end


initiate()


