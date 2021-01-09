require 'open-uri'
require 'json'

class GamesController < ApplicationController
  protect_from_forgery with: :null_session

  def new
    @start_time = Time.now
    @grid_size = params[:size].to_i
    if @grid_size.positive?
      @letters = []
      @grid_size.times { @letters << ('A'..'Z').to_a.sample }
      @letters
    else
      render :welcome
    end
  end

  def score
    @end_time = Time.now
    @attempt = params[:word]
    @letters = params[:grid].scan(/[a-zA-Z]+/)
    @start_time = Time.new(params[:start_time])
    @time = @end_time - @start_time
    if english_word?(@attempt) && in_the_grid?(@attempt, @letters)
      @score = ((@attempt.size / @time) * 10**6).round(2)
    else
      @score = 0
    end
    @result_message = result_message(@attempt, @letters)
  end

  private

  def english_word?(attempt)
    api_url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    result = JSON.parse(open(api_url).read)
    result["found"]
  end

  def in_the_grid?(attempt, grid)
    grid_copy = grid.dup
    attempt.upcase.each_char do |letter|
      if grid_copy.include?(letter)
        grid_copy.delete_at(grid_copy.index(letter))
      else
        return false
      end
    end
  end

  def result_message(attempt, grid)
    if english_word?(attempt) && in_the_grid?(attempt, grid)
      "That's a word! Keep going!"
    elsif !english_word?(attempt)
      "That's not a word..."
    elsif !in_the_grid?(attempt, grid)
      "Your word is not in the grid..."
    end
  end
end
