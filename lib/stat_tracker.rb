require 'csv'
require 'pry'
require_relative './game'
require_relative './team'
require_relative './game_team'
require_relative '../modules/game_statables'
require_relative '../modules/league_statables'
require_relative '../modules/team_statables'
require_relative '../modules/team_stat_helper'
require_relative '../modules/season_stat_helper'
require_relative '../modules/game_stat_helper'
require_relative '../modules/stat_tracker_helper'
require_relative '../modules/season_statables'

class StatTracker
  include GameStatables
  include LeagueStatables
  include TeamStatables
  include SeasonStatables
  include TeamStatHelper
  include SeasonStatHelper
  include GameStatHelper
  include StatTrackerHelper
  attr_reader :games, :teams, :game_teams

  def initialize(games = {}, teams = {}, game_teams = {})
    @games = games
    @teams = teams
    @game_teams = game_teams
  end

  def self.create_games(location)
    games = Hash.new
    CSV.foreach(location, :headers => true) do |row|
      games[row.first[1]] = Game.new(row)
    end
    games
  end

  def self.create_teams(location)
    teams = Hash.new
    CSV.foreach(location, :headers => true) do |row|
      teams[row.first[1]] = Team.new(row)
    end
    teams
  end

  def self.create_game_teams(location)
    game_teams = Hash.new
    CSV.foreach(location, :headers => true).with_index do |row, i|
      game_teams[i + 1] = GameTeam.new(row)
    end
    game_teams
  end

  def self.from_csv(locations)
    games = create_games(locations[:games])
    teams = create_teams(locations[:teams])
    game_teams = create_game_teams(locations[:game_teams])
    StatTracker.new(games, teams, game_teams)
  end

end
