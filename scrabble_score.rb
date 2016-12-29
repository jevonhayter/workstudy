# Program to score the points awarded for letters in a scrabble game
class Scrabble
  def initialize(word)
    @word = word
  end

  def word
    if @word == nil?
      ' '
    else
      @word.upcase
    end
  end

  def process
    total = 0
    word.upcase.chars.each do |letter|
      total += points(letter)
    end
    total
  end

  def points(letter)
    case letter
      when 'A', 'E', 'I', 'O', 'U', 'L', 'N', 'R', 'S', 'T' then 1
      when 'D', 'G'                                         then 2
      when 'B', 'C', 'M', 'P'                               then 3
      when 'F', 'H', 'V', 'W', 'Y'                          then 4
      when 'K'                                              then 5
      when 'J', 'X'                                         then 8
      when 'Q', 'Z'                                         then 10
      else                                                       0
    end
  end
end
