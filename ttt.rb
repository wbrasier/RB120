require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize(human_marker)
    @squares = {}
    @human = human_marker
    reset
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  # return winning marker or nil
  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if identical_markers?(squares, 3)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def immediate_threat_or_win?
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if identical_markers?(squares, 2)
        return true
      end
    end
    false
  end

  def find_high_reward_square
    [TTTGame::COMPUTER_MARKER, @human.marker].each do |marker_check|
      WINNING_LINES.each do |line|
        squares = @squares.values_at(*line)
        if collect_markers(squares).count(marker_check) == 2
          line.each { |space| return space if unmarked_keys.include?(space) }
        end
      end
    end
  end

  private

  def collect_markers(squares)
    squares.select(&:marked?).collect(&:marker)
  end

  def identical_markers?(squares, number_in_a_row)
    markers = collect_markers(squares)
    return false if markers.size != number_in_a_row
    markers.uniq.size == 1
  end
end

class Square
  INITIAL_MARKER = ' '
  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  COMPUTER_MARKER = 'O'
  ULTIMATE_WINNER = 5

  attr_reader :board, :human, :computer, :human_marker, :player_name,
              :computer_name
  attr_accessor :first_to_move

  def play
    clear
    main_game
    display_goodbye_message
  end

  private

  def initialize
    display_welcome_message
    @human = Player.new(pick_marker)
    @board = Board.new(@human)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = ''
    @@human_score = 0
    @@computer_score = 0
    @first_to_move = ''
  end

  def display_welcome_message
    system 'clear'
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def main_game
    pick_and_assign_names
    pick_first_player
    loop do
      display_board
      player_move
      display_result
      break unless play_again?
      reset
      display_play_again_message
    end
  end

  def pick_marker
    answer = ''
    loop do
      puts "Pick any single character aside from O to be your marker."
      answer = gets.chomp
      break if answer.size == 1 && answer != 'O'
    end
    @human_marker = answer
  end

  def pick_first_player
    answer = ''
    loop do
      puts "Who would you like to go first?"
      puts "#{player_name} (human), #{computer_name} (computer), or random?"
      puts "h, c, or r."
      answer = gets.chomp.downcase
      break if %(h c r).include?(answer)
      puts "Sorry select h, c, or r."
    end
    @current_marker = first_player_selection(answer)
  end

  def pick_and_assign_names
    answer = ''
    loop do
      puts "What is your name?"
      answer = gets.chomp
      break unless answer.empty?
    end
    @player_name = answer
    @computer_name = ["Harry", 'Cynthia', 'Coco', 'Buddy'].sample
  end

  def first_player_selection(first)
    @first_to_move = case first
                     when 'h'
                       @human_marker
                     when 'c'
                       COMPUTER_MARKER
                     else
                       [@human_marker, COMPUTER_MARKER].sample
                     end
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "#{player_name} a #{human.marker}."
    puts "#{computer_name} is a #{computer.marker}"
    puts "Reach #{ULTIMATE_WINNER} wins to be the ultimate winner!"
    puts ""
    board.draw
    puts ""
  end

  def joinor(empty_squares, delimiter = ', ', joining_word = 'or')
    if empty_squares.size > 2
      string = empty_squares.join(delimiter)
      string[-2] = " #{joining_word} "
    else
      string = empty_squares.join(" #{joining_word} ")
    end
    string
  end

  def human_moves
    puts "Choose a square from #{joinor(board.unmarked_keys)}: "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice"
    end

    board[square] = human.marker
  end

  def computer_moves
    move = computer.marker
    if board.immediate_threat_or_win?
      board[board.find_high_reward_square] = move
    elsif board.unmarked_keys.include?(5)
      board[5] = move
    else
      board[board.unmarked_keys.sample] = move
    end
  end

  def display_result
    clear_screen_and_display_board
    if board.winning_marker == human.marker
      puts "You won!"
    elsif board.winning_marker == computer.marker
      puts "#{computer_name} won!"
    else
      puts "The board is full!"
    end
    update_overall_score(board.winning_marker)
    display_overall_scores
  end

  def display_overall_scores
    puts "You have won #{@@human_score} times."
    puts "#{computer_name} has won #{@@computer_score} times."
    display_ultimate_winner if ultimate_winner?
  end

  def update_overall_score(winner)
    if winner == computer.marker
      @@computer_score += 1
    elsif winner == human.marker
      @@human_score += 1
    end
  end

  def ultimate_winner?
    @@human_score == ULTIMATE_WINNER || @@computer_score == ULTIMATE_WINNER
  end

  def display_ultimate_winner
    if @@human_score == 5
      puts "The ultimate winner is YOU!"
    else
      puts "The ultimate winner is the computer!"
    end
  end

  def play_again?
    answer = ''
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %(y n).include?(answer)
      puts "Sorry, must be y or n."
    end
    answer == 'y'
  end

  def clear
    system 'clear'
  end

  def reset
    board.reset
    @current_marker = @first_to_move
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = @human_marker
    end
  end

  def human_turn?
    @current_marker == @human_marker
  end
end

game = TTTGame.new
game.play
