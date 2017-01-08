# Progam to print number series from string by n number given to program
class Series
  attr_reader :string

  def initialize(string)
    # Convert string to interges and assign to instance variable
    @string = string.chars.map(&:to_i)
  end

  def slices(number)
    # Slice the array by the number passed into the method
    raise ArgumentError, 'Number is to large' if number > string.size
    slices = []

    while string.size >= number
      slices << string.slice(0..number - 1)
      string.delete_at(0)
    end

    slices
  end
end
