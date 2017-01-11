# Program to score a bowling game
class Game
  attr_reader :rolls

  def initialize
    @rolls = []
  end

  def roll(pins)
    check_pins_are_valid?(pins)

    @rolls << pins

    check_frame_pins_count_valid?(rolls)
    check_if_game_is_over?(rolls)
  end

  def score
    check_we_have_reached_end_of_game?(rolls)
    check_perfect_score_end_of_game?(rolls)

    return 300 if rolls.all? { |pins| pins == 10 }

    # Calculates all strikes in the game
    if strikes_that_are_not_last_frame?(rolls)
      strike_calculation(rolls)

    # Calculates all spares in the game
    elsif spares_that_are_not_last_frame?(rolls)
      spare_calculation(rolls)

    # Calculates all open frames
    else
      rolls.reduce(:+)
    end
  end

  # Helper Methods
  def strikes_that_are_not_last_frame?(rolls)
    rolls if rolls.slice(0, 17).include?(10) && !rolls.slice(17..20).include?(10)
  end

  def spares_that_are_not_last_frame?(rolls)
    rolls if rolls.take(2).reduce(:+) == 10 && !rolls.slice(18..-1).include?(10)
  end

  # Exceptions
  def check_pins_are_valid?(pin)
    raise 'Pins must have a value from 0 to 10' unless (0..10).cover?(pin)
  end

  def check_frame_pins_count_valid?(rolls)
    if !rolls.include?(10) && rolls.take(2).reduce(:+) > 10
      raise 'Pin count exceeds pins on the lane'
    elsif rolls[18] == 10 && !rolls[19..20].include?(10) && rolls[19..20].reduce(:+).to_i > 10
      raise 'Pin count exceeds pins on the lane'
    end
  end

  def check_we_have_reached_end_of_game?(rolls)
    raise 'Score cannot be taken until the end of the game' if
    !rolls.include?(10) && rolls.size < 20
  end

  def check_if_game_is_over?(rolls)
    raise 'Should not be able to roll after game is over' if
    !rolls.include?(10) && rolls.size > 20 && rolls.slice(18..19).reduce(:+) != 10
  end

  def check_perfect_score_end_of_game?(rolls)
    raise 'Game is not yet over, cannot score!' if
    rolls.size < 12 && rolls.all? { |pins| pins == 10 }
  end

  private

  def strike_calculation(rolls)
    find_index_of_strikes =
      rolls.each_index.select { |index| rolls[index] == 10 }

    strike_numbers = find_index_of_strikes.map { |i| rolls.slice(i, 3) }
                                          .map { |i| i.reduce(:+) }
                                          .reduce(:+)

    rolls_wt_strikes = rolls.each_index
                            .select { |index| rolls[index] != 10 }

    without_strike_numbers = rolls_wt_strikes.map { |i| rolls[i] }.reduce(:+)
    strike_numbers + without_strike_numbers
  end

  def spare_calculation(rolls)
    value_10_pairs =
      rolls.each_slice(2).select { |slice| slice.reduce(:+) == 10 }

    pair_indexes = value_10_pairs.map { |pair| rolls.rindex(pair[1]) }
                                 .map { |index| index + 1 }

    counter = 0
    spare_arrays =
      value_10_pairs.each do |pair|
        pair << rolls[pair_indexes[counter]]
        counter += 1
      end

    arrays_spare_value = spare_arrays.map { |pair| pair.reduce(:+) }.reduce(:+)

    not_value_10_pairs = rolls.each_slice(2)
                              .select { |slice| slice.reduce(:+) != 10 }
                              .flatten.reduce(:+)

    arrays_spare_value + not_value_10_pairs
  end
end
