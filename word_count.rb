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
    @word_keeper = {}

    string.each do |word|
      @word_keeper[word] = string.count(word)
    end
    @word_keeper
  end
end
