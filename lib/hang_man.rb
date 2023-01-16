require 'yaml'
require_relative 'YAML.rb'

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
  def new_word
    @word = File.readlines("dictionary.txt").select { |w| w.length > 5 && w.length < 12}.sample.chomp
  end
end

class Game

  def save_game(characters)
    yam = YAML::dump(characters)
    dirname = "my_game"
    Dir.mkdir(dirname) unless File.exists?(dirname)
    File.open("#{dirname}/saved.yaml", 'w'){|f| f.write(yam)}
  end

  def player_input(player)
    puts "Please enter a letter guess or type 'save' to save game"
    input = gets.chomp
    if input == 'save'
      save_game(player)
      puts "Game Saved!"
      player_input(player)
    elsif !input.match(/[[:alpha:]]/) || input.length > 1
      puts "please only enter ONE alphabetical value"
      player_input(player)
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
    p player.display.join
    game_cycle(player)
  end

  def load_game
    player = File.open("my_game/saved.yaml", 'r') { |fh|  player = YAML.load( fh ) }
    Game.new.play_game(player)
  end

  def hangman_intro
    puts "                 *********  HANGMAN  ************ "
    puts "What is your Name?"
    input = gets.chomp
    puts "Hello, #{input} I'll pick a word and you have to try to guess it letter by letter."
    player = Player.new(input)
    player.new_word
    Game.new.play_game(player)
  end

  def initiate 
    if File.exist?("my_game/saved.yaml")
      puts "Load saved game?"
      input = gets.chomp
      input == 'yes' ? load_game : hangman_intro
    else
    hangman_intro
    end
  end
end


Game.new.initiate
