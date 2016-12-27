# Program to count how many duplicate words are in a phrase.
class Phrase
  def initialize(string)
    @string = string.downcase
  end

  def string
    @string.tr(',', ' ')
           .delete(':')
           .split
           .each do |word|
      word.gsub!(/[^abcdefghijklmnopqrstuvwxyz0123456789: ]/, '')
    end
  end

  def count_words
    @count = {}

    string.each do |word|
      @count[word] = string.count(word)
    end
    @count
  end
end
word = Phrase.new("Joe can't tell between 'large' and large.")
puts word.count_words
