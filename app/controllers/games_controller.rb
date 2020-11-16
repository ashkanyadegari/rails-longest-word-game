require 'open-uri'
require 'json'
require 'set'

class GamesController < ApplicationController
    def new
        @letters = generate_grid(10)
    end

    def score
        @answer = params[:word]
        @start_time = Time.parse(params[:starttime])
        @end_time = Time.now
        @grid = JSON.parse(params[:grid])
        @result = run_game(@answer, @grid, @start_time, @end_time)
    end

    private

    def generate_grid(grid_size)
        # TODO: generate random grid of letters
        grid = 0
        final_grid = []
        until grid == grid_size
          final_grid << ("A".."Z").to_a.sample
          grid += 1
        end
        final_grid
      end
      
      def in_grid?(attempt, grid)
        split_word = attempt.upcase.split("")
        p split_word
        in_grid = true
        split_word.each do |letter|
          if split_word.count(letter) > grid.count(letter)
            in_grid = false
            break
          end
        end
        in_grid
      end
      
      def api_call(attempt)
        url = "https://wagon-dictionary.herokuapp.com/#{attempt.downcase}"
        user_serialized = open(url).read
        JSON.parse(user_serialized)
      end
      
      def run_game(attempt, grid, start_time, end_time)
        # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
        user = api_call(attempt)
        time = end_time - start_time
        if in_grid?(attempt, grid) == false
          { score: 0, message: "is not in the grid", time: time }
        elsif user["found"] == false
          { score: 0, message: "is not an english word", time: time }
        else
          score = attempt.length / time
          { score: score, message: "is in the grid and is an English word. Well Done", time: time }
        end
      end
      
end
