# make a guessing game with a set amount of guesses to guess a number
# the user enters a number within a set range
#     can't exceed or the range on either end
# After the guess say if the guess is lower or higher than the random number
# Let the user know when they guess the number- won the game
# If the user doesn't get the number in the amount of guesses, they lose

class GuessingGame
  attr_accessor :guesses_used, :guess
  attr_reader :range, :guesses, :lower_limit, :upper_limit
  
  def initialize(lower_limit, upper_limit)
    @lower_limit = lower_limit
    @upper_limit = upper_limit
    @range = (lower_limit..upper_limit).to_a
    @guesses = Math.log2(range.size).to_i + 1
    @secret_num = range.sample
    @guesses_used = 0
    @guess = nil
  end
  
  def play
    loop do
      display_guesses
      ask_for_number
      evaluate_guess
      break if won? || no_guesses?
      display_lose_message
    end
  end
  
  private
  attr_reader :secret_num
  
  def won?
    guess == secret_num
  end
  
  def display_lose_message
    puts "You have no more guesses. You lost!"
  end
  
  def no_guesses?
    guesses_used == guesses
  end
  
  def display_win
    puts "That's the number!"
    puts ""
    puts "You won!"
  end
  
  def display_too_high
    puts "Your guess is too high."
    puts ""
  end
  
  def display_too_low
    puts "Your guess is too low."
    puts ""
  end
  
  def evaluate_guess
    if won?
      display_win
    elsif guess > secret_num
      display_too_high
    else
      display_too_low
    end
    self.guesses_used += 1
  end
  
  def display_guesses
    puts "You have #{guesses - guesses_used} guesses remaining."
  end
  
  def ask_for_number
    answer = ''
    puts "Enter a number between #{lower_limit} and #{upper_limit}: "
    loop do
      answer = gets.chomp.to_i
      break if range.include?(answer)
      puts "Invalid guess. Enter a number between #{lower_limit} and #{upper_limit}: "
    end
    self.guess = answer
  end
  
  def display_guesses
    puts "You have #{guesses - guesses_used} guesses remaining."
  end
  
  def ask_for_number
    answer = ''
    puts "Enter a number between #{lower_limit} and #{upper_limit}: "
    loop do
      answer = gets.chomp.to_i
      break if range.include?(answer)
      puts "Invalid guess. Enter a number between #{lower_limit} and #{upper_limit}: "
    end
    self.guess = answer
  end
end



game = GuessingGame.new(501, 1500)
game.play
