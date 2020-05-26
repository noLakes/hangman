require 'yaml'

module Hangman
  HANGMAN_TEXT = {
    0 => "     +---+\n     |   |\n         |\n         |\n         |\n         |\n ===========",
    1 => "     +---+\n     |   |\n     O   |\n         |\n         |\n         |\n ===========",
    2 => "     +---+\n     |   |\n     O   |\n     |   |\n         |\n         |\n ===========",
    3 => "     +---+\n     |   |\n     O   |\n    /|   |\n         |\n         |\n ===========",
    4 => "     +---+\n     |   |\n     O   |\n    /|\\  |\n         |\n         |\n ===========",
    5 => "     +---+\n     |   |\n     O   |\n    /|\\  |\n    /    |\n         |\n ===========",
    6 => "     +---+\n     |   |\n     O   |\n    /|\\  |\n    / \\  |\n         |\n ==========="
    }
  WORDS = File.readlines("/Users/Shan/web-projects/odin_on_rails/ruby_projects/hangman/5desk.txt")

  def randomWord
    WORDS.sample.strip
  end

end

class Game
  include Hangman
  attr_reader :lives, :turn, :guesses
  
  def initialize
    @word = randomWord
    @lives = 6
    @guesses = []
    start
  end

  private
  attr_reader :word

  def start 
    puts " ===========\n   HANGMAN\n ==========="
    puts "\n You may save the game by entering 'save' at any time you would enter a guess."
    puts "\n Would you like to load a previous save? [y/n]"
    if gets.chomp == 'y'
      puts " Please enter the filename you wish to load from:"
      load(gets.chomp)
    else
      turn
    end
  end

  def save(save_name)
    data = YAML.dump ({
      :word => @word,
      :lives => @lives,
      :guesses => @guesses,
    })
    save =  File.open(save_name, 'w')
    save.puts(data)
    puts "Game saved as #{save_name}.yaml"
  end

  def load(save_name)
    data = YAML.load(File.read(save_name))
    @word = data[:word]
    @lives = data[:lives]
    @guesses = data[:guesses]
    turn
  end

  def turn
    game_over if @lives == 0
    puts "#{HANGMAN_TEXT[6 - @lives]}\n Lives: #{@lives}\n Wrong: #{incorrect}\n #{show_word}"
    get_guess
    check_win
    turn
  end

  def show_word
    show = @word.split('').map do |char|
      if @guesses.include?(char.downcase) || @guesses.include?(char.upcase)
        char
      else
        '_'
      end
    end
    show.join(' ')
  end

  def check_win
    test = @guesses.select {|char| @word.include?(char.downcase) || @word.include?(char.upcase)}
    win if @word.split('').uniq.length == test.length
  end

  def win
    puts "You won! You guessed the word #{@word.upcase} with #{@lives} lives left"
    new_game
  end

  def game_over
    puts "#{HANGMAN_TEXT[6]}\n You died!\n The word was: #{@word.upcase}"
    new_game
  end

  def get_guess
    puts "\nGuess a letter:"
    guess = gets.chomp
    if guess.length.zero?
      puts "Error: No input!"
      get_guess
    elsif guess.downcase == 'save'
      puts "Please enter save name:"
      save(gets.chomp)
    elsif !guess[0].downcase.ord.between?(97, 122)
      puts "Error: Guess not a letter!"
      get_guess
    elsif @guesses.include?(guess[0].downcase) || @guesses.include?(guess[0].upcase)
      puts "You've already guessed (#{guess})"
      get_guess
    else
      @guesses << guess[0].downcase
      @lives -= 1 if !@word.include?(guess[0].downcase) && !@word.include?(guess[0].upcase)
    end
  end

  def incorrect
    "(#{@guesses.select {|char| !@word.include?(char.downcase) && !@word.include?(char.upcase)}.join(' ')})"
  end

  def new_game
    sleep 0.5
    puts "\n Would you like to play again? [y/n]"
    gets.chomp == 'y' ? initialize : exit
  end
end

Game.new
