require_relative 'computer'
require_relative 'player'
require 'byebug'

class Game

  attr_reader :referee, :human, :dictionary, :secret_word, :board

  #human is guesser
  #referee is computer player

  def initialize(referee = Computer.new, human = Human.define_name, dictionary)
    @referee = referee
    @human = human
    @dictionary = dictionary
    @board = []
    @guesses = []
    @failed_guess_count = 0
  end

  def play
    setup
    # byebug

    until game_over?

      display
      letter = human.take_guess
      correct_indices = referee.check_guess(letter)
      if correct_indices.empty?
        @failed_guess_count += 1 unless @guesses.include?(letter)
      end
      @guesses << letter unless @guesses.include?(letter)
      handle_response(letter, correct_indices)
    end
    display

    if won?
      puts "Congratulations! You won!"
      play_again?
    else
      puts "Sorry, you lost"
      puts "The correct word was #{@secret_word}"
      play_again?
    end
  end

  def play_again?
    puts "Play again? (y/n)"
    input = gets.chomp
    if input == "y"
      play
    else
      puts  "Goodbye"
    end
  end

  def setup
    @guesses = []
    @failed_guess_count = 0
    print "Enter difficulty level (easy, medium, hard): "
    difficulty_level = gets.chomp
    shorten_dictionary(difficulty_level)
    @secret_word = @referee.pick_secret_word(@dictionary)
    @board = Array.new(secret_word.length) {'_'}
  end

    def display
      p @board.join("  ")
      system('clear')
      puts "Failed guess count: #{@failed_guess_count}"
      puts "Guesses: #{@guesses.join("   ")}"

      # puts "You have #{@failed_guess_count} failed guesses."
      progress = "Your progress: "
      @secret_word.each_char do |ch|
  	     @guesses.include?(ch) ? progress += " #{ch} " : progress += " _ "
	     end
      puts progress
    end

  def handle_response(letter, indices)
    indices.each do |idx|
      board[idx] = letter
    end
  end

  def game_over?
    @failed_guess_count == 6 || won?
  end

  def won?
    @board.none? {|el| el == "_"}
  end

  def lost?
    @failed_guess_count == 6
  end

  def shorten_dictionary(level)
    if level == "easy"
      @dictionary.select!{|word| word.length < 5}
    elsif level == "medium"
      @dictionary.select!{|word| word.length < 6}
    elsif level == "hard"
      @dictionary.select!{|word| word.length >= 6}
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  dictionary = File.readlines("dictionary.txt")
  dictionary.map!{|line| line.chomp}
  h = Human.new("Human")
  c = Computer.new
  g = Game.new(c, h, dictionary)
  g.play
end
