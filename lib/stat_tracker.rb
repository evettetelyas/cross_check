require 'csv'
require 'pry'
require_relative './game'
require_relative './team'
require_relative '../modules/game_statables'

class StatTracker
  include GameStatables
  attr_reader :games, :teams

  def initialize(games = {}, teams = {})
    @games = games
    @teams = teams
  end

  def self.create_games(location)
    @games = {}
    options = {:headers => true, :header_converters => :symbol}
    CSV.foreach(location, options) do |row|
      @games[row.first[1]] = Game.new(row)
    end
  end

  def self.create_teams(location)
    @teams = {}
    options = {:headers => true, :header_converters => :symbol}
    CSV.foreach(location, options) do |row|
      @teams[row.first[1]] = Team.new(row)
    end
  end

  def self.from_csv(locations)
    games = create_games(locations[:dummy_games])
    teams = create_teams(locations[:dummy_teams])
    StatTracker.new(@games, @teams)
  end

end
