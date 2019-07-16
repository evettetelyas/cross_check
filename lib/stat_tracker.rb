require 'csv'
require 'pry'
require_relative './game'
require_relative '../modules/game_statables'

class StatTracker
  include GameStatables
  attr_reader :games

  def initialize(games = {})
    @games = games
  end

  def self.create_games(location)
    @games = {}
    options = {:headers => true, :header_converters => :symbol}
    CSV.foreach(location, options) do |row|
      @games[row.first[1]] = Game.new(row)
    end
  end

  def self.from_csv(locations)
    games = create_games(locations[:dummy_games])
    StatTracker.new(@games)
  end

end
