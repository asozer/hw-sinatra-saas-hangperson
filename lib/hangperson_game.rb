class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end



  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(letter)
    if letter == nil
      raise ArgumentError, 'Must not be Nil'
    elsif not letter =~ /[[:alpha:]]/
      raise ArgumentError, 'Must be alphabetic'
    elsif letter == ''
      raise ArgumentError, 'Empty String'
    elsif @word.include?(letter.downcase)
      if not @guesses.include?(letter.downcase)
        @guesses << letter.downcase
      else 
        return false
      end
    elsif not @wrong_guesses.include?(letter.downcase)
      @wrong_guesses << letter.downcase
    else 
      return false
    end
  end

  def word_with_guesses
    if @guesses.length() > 0
      @word.gsub(/[^#{@guesses}]/, '-')
    else
      @word.gsub(/./, '-')
    end 
  end

  def guess_several_letters(game, letters)
    for letter in letters
      game.guess(letter)
    end
  end



  def check_win_or_lose
    if @wrong_guesses.length() >= 7
      return :lose
    elsif @guesses.length() == @word.length()
      return :win
    else 
      return :play
    end
  end 



end
