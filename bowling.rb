# Program to calculate bowling game score.
class Game
  attr_accessor :rolls

  def initialize
    @rolls = []
  end

  def roll(pins)
    raise RuntimeError, 'Pins must have a value from 0 to 10' if pins < 0
    raise RuntimeError, 'Pins must have a value from 0 to 10' if pins > 10
    rolls << pins if rolls.size < 21
    raise RuntimeError, 'Pin count exceeds pins on the lane' unless rolls.take(2).reduce(:+) <= 10
  end

  def score
    return 300 if rolls.all? { |pins| pins == 10 }
    
    if rolls.slice(0, 17).include?(10)
      strike_calculation(rolls)
    elsif rolls.take(2).reduce(:+) == 10
      spare_calculation(rolls)
    elsif rolls.fetch(18) == 10
      rolls.fetch(18) + rolls.fetch(19) + rolls.fetch(20) +
      rolls.slice(0, 18).reduce(:+)
    else
      rolls.reduce(:+)
    end
  end

  private

  def strike_calculation(rolls)
    find_index_of_tens = rolls.each_index
                              .select { |index| rolls[index] == 10 }
    strike_numbers = find_index_of_tens.map { |i| rolls.slice(i, 3) }
    strikes_reduced = strike_numbers.map { |i| i.reduce(:+) }
    strike_value = strikes_reduced.reduce(:+)
    rolls_wt_strikes = rolls.each_index
                            .select { |index| rolls[index] != 10 }
    without_strike_numbers = rolls_wt_strikes.map { |i| rolls[i] }
    without_stike_value = without_strike_numbers.reduce(:+)
    strike_value + without_stike_value
  end

  def spare_calculation(rolls)
    value_10_pairs = rolls.each_slice(2)
                          .select { |slice| slice.reduce(:+) == 10 }
    pair_indexes = value_10_pairs.map { |pair| rolls.rindex(pair[1]) }
    find_pin_index = pair_indexes.map { |index| index + 1 }

    counter = 0
    spare_arrays = value_10_pairs.each do |pair|
                     pair << rolls[find_pin_index[counter]]
                     counter += 1
                   end

    arrays_spare_value = spare_arrays.map { |pair| pair.reduce(:+) }
    spare_total = arrays_spare_value.reduce(:+)
    not_value_10_pairs = rolls.each_slice(2)
                              .select { |slice| slice.reduce(:+) != 10 }
    single_pins = not_value_10_pairs.flatten.reduce(:+)
    spare_total + single_pins
  end
end
