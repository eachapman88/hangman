
require "byebug"

class Computer

  # def initialize
  # end

  def pick_secret_word(dictionary)
    @secret_word = dictionary.sample
  end

  def check_guess(letter)
    indices = []
    @secret_word.chars.each_with_index do |char,idx|
      indices << idx if letter == char
    end
    indices
  end



end
