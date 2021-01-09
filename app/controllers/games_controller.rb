class GamesController < ApplicationController
    def new
        @letters = []
        (5..45).to_a.sample.times{ @letters << ('A'..'Z').to_a.sample }
        return @letters
    end

    def score
        @word = params[:word]
        
    end
end
