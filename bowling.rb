class Game
  attr_reader :rolls
 
  def initialize
    @rolls = Array.new
  end
  #Exceptions --------------------------------------------------
 
  def pin_value_exception(pin)
    raise RuntimeError, 'Pins must have a value from 0 to 10' unless (0..10).include?(pin)
  end
 
  def lane_pin_count(rolls)
    if !rolls.include?(10) && rolls.take(2).reduce(:+) > 10
      raise RuntimeError, 'Pin count exceeds pins on the lane'
    elsif rolls[18] == 10 && !rolls[19..20].include?(10) && rolls[19..20].reduce(:+).to_i  > 10
      raise RuntimeError, 'Pin count exceeds pins on the lane'
    end
  end
 
  def end_of_game?(rolls)
    if !rolls.include?(10) && rolls.size < 20
      raise RuntimeError, 'Score cannot be taken until the end of the game'
    end
  end
 
  def after_game?(rolls)
    if !rolls.include?(10) && rolls.size > 20 && rolls.slice(18..19).reduce(:+) != 10
      raise RuntimeError, 'Should not be able to roll after game is over' 
    end
  end
 
  def perfect_score_end_of_game?(rolls)
    if rolls.size < 12 && rolls.all? { |pins| pins == 10 }
      raise RuntimeError, 'Game is not yet over, cannot score!' #if @rolls.size == 10
    end
  end
 
  
  
  def roll(pins)
    pin_value_exception(pins)
   
    @rolls << pins
   
    lane_pin_count(rolls)
    after_game?(rolls)
  end
 
  def score
    end_of_game?(rolls)
    perfect_score_end_of_game?(rolls)
   
    return 300 if rolls.all? { |pins| pins == 10 }
   
    if strikes_that_are_not_last_frame?(rolls)
      strike_calculation(rolls)
    elsif spares_that_are_not_last_frame?(rolls)
      spare_calculation(rolls)
    elsif last_frame_strike?(rolls)
      (rolls.fetch(18) + rolls.fetch(19) + rolls.fetch(20)) + rolls.slice(0, 18).reduce(:+)
    elsif last_frame_spare?(rolls)
      spare_calculation(rolls)
    elsif last_frame_open?(rolls)
      (rolls.fetch(18) + rolls.fetch(19) + rolls.fetch(20)) + rolls.slice(0, 18).reduce(:+)
    elsif last_frame_all_stikes?(rolls)
      spare_calculation(rolls)
    else
     rolls.reduce(:+)
    end
  end
 
  #Helper Methods
 
  def strikes_that_are_not_last_frame?(rolls)
    return rolls if rolls.slice(0, 17).include?(10) && !rolls.slice(17..20).include?(10)
  end
 
  def spares_that_are_not_last_frame?(rolls)
    return rolls if rolls.take(2).reduce(:+) == 10 && !rolls.slice(18..-1).include?(10)
  end
 
  def last_frame_strike?(rolls)
    rolls.fetch(18) == 10
  end
 
  def last_frame_open?(rolls)
    rolls.fetch(18) == 10 && rolls.slice(19..20)
  end
 
  def last_frame_spare?(rolls)
    rolls.slice(18..19) == 10
  end
 
  def last_frame_all_stikes?(rolls)
    rolls.slice(18..10) == 30
  end
 
  
  
  def roll_n_times(rolls, pins)
    rolls.times do
      Array(pins).each { |value| roll(value) }
    end
  end
 
  
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
 
 