# Program to validate phone number for sms use.
class PhoneNumber
  BAD_NUMBER = '0000000000'.freeze

  def initialize(number)
    @number = number.scan(/\h/).join
  end

  def number
    clean_number = letter_check(@number)

    if clean_number.size < 10
      BAD_NUMBER
    elsif clean_number.size == 11
      eleven_clean(clean_number)
    elsif clean_number.size == 10
      clean_number
    elsif clean_number.size > 11
      BAD_NUMBER
    end
  end

  def eleven_clean(number)
    if number[0] == '1'
      number.slice!(0)
      number
    else
      BAD_NUMBER
    end
  end

  def letter_check(number)
    number.chars.any? { |val| /^[a-zA-Z]/ =~ val } ? BAD_NUMBER : number
  end

  def area_code
    number.slice(0, 3)
  end

  def to_s
    "(#{area_code}) #{number.slice(3, 3)}-#{number.slice(6, 4)}"
  end
end
