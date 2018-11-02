class Human

  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def take_guess
    puts "#{name.capitalize}, what letter do you guess?"
    letter = gets.chomp
    is_valid?(letter) ? letter : take_guess
  end

  def is_valid?(letter)
    ('a'..'z').include?(letter.downcase)
  end

end
