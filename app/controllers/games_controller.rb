class GamesController < ApplicationController
  require "open-uri"

  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split(',')
    if check_word_with_letters(@word, @letters)
      url = "https://wagon-dictionary.herokuapp.com/#{@word}"
      dic = JSON.parse(open(url).read)
      if dic["found"]
        @msg = "Congratulations! #{@word} is a valid English word!"
      else
        @msg = "Sorry but #{@word} does not seem to be a valid English word..."
      end
    else
      @msg = "Sorry but #{@word} can't be build out of #{params[:letters]}"
    end
  end

  private

  def check_word_with_letters(word, letters)
    # Create a hash with the letters and their count
    letters_hash = Hash.new(0)
    letters.each { |l| letters_hash[l] += 1 }
    # Create a hash with the letters of the word and their count
    word_hash = Hash.new(0)
    word.split('').each { |l| word_hash[l] += 1 }

    word_hash.each do |k, v|
      return false if !letters_hash.key?(k) || letters_hash[k] < v
    end
  end
end
