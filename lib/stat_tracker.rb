require 'csv'
require 'pry'
require_relative './game'

class StatTracker

  def initialize(games)
    @games = games
  end

  def self.from_csv
    @games = create_games('./data/game.csv')
  end

  def self.create_games
    @games = {}
    options = {:headers => true, :header_converters => :symbol}
    CSV.foreach('./cross_check/data/game.csv', options) do |row|
      @games[row.first.each] = Game.new(row)
    end
  end

  binding pry


end
