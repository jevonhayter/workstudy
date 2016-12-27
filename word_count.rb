# Program to count how many duplicate words are in a phrase.
class Phrase
  def initialize(phrase)
    @phrase = phrase.downcase
  end

  def phrase
    @phrase.tr(',', ' ')
           .delete(':')
           .split
           .each do |word|
      word.gsub!(/[^abcdefghijklmnopqrstuvwxyz0123456789: ]/, '')
    end
  end

  def count_words
    @word_keeper = {}

    phrase.each do |word|
      @word_keeper[word] = phrase.count(word)
    end
    @word_keeper
  end
end
