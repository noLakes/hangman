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
    WORDS.sample.strip.split('')
  end

end

class Game
  include Hangman
  attr_reader :lives, :turn, :guesses
  
  def initialize
    @word = randomWord
    @secret_word = []
    (@word.length).times {@secret_word << '_'}
    @lives = 6
    @guesses = []
    start
  end

  private

  def start 
    puts " ===========\n   HANGMAN\n ==========="
    puts "\n Would you like to load a previous save? [y/n]"
    #gets answer
    turn
  end

  def turn
    puts "#{HANGMAN_TEXT[6 - @lives]}\n Lives: #{@lives}\n Wrong: #{incorrect}\n #{@secret_word.join(' ')}"
    
  end

  def incorrect
    "(#{@guesses.join(' ')})"
  end

end

Game.new
