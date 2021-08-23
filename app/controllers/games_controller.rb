require 'open-uri'

class GamesController < ApplicationController
  def new
    range = (5..10).to_a.sample
    @letters = ("A".."Z").to_a.sample(range).join
  end

  def score
    @word = params[:word]
    @grid = params[:grid]
    valid_word = @word.upcase.split("").all? { |letter| @grid.include? letter }
    if valid_word
      # is english word?
      if word_valid?(@word)
        # compute score
        attempt_points = @word.length
        @message = "Well done! You scored #{attempt_points} in this attempt. Your current cumulative score: #{session[:points]}"
      else
        @message = 'The word you entered is not an english word.'
      end
    else
      @message = 'Fail! The rules are simple: you have to make a word using the letters provided in the grid'
    end
  end

  def word_valid?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = URI.open(url).read
    result = JSON.parse(response)
    result['found']
  end
end
