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

  def self.from_csv
    self.create_games
  end

  def self.dummy_from_csv
    self.dummy_create_games
  end

  def self.create_games
    @games = {}
    options = {:headers => true, :header_converters => :symbol}
    CSV.foreach('./cross_check/data/game.csv', options) do |row|
      @games[row.first[1]] = Game.new(row)
    end
  end

  def self.dummy_create_games
    @games = {}
    options = {:headers => true, :header_converters => :symbol}
    CSV.foreach('./cross_check/dummy_data/dummy_game.csv', options) do |row|
      @games[row.first[1]] = Game.new(row)
    end
  end
binding pry
end
