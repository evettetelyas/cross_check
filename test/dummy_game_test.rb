require 'simplecov'
require 'minitest/autorun'
require 'minitest/pride'
SimpleCov.start
require './lib/stat_tracker'
require './lib/game'
require './lib/team'
require './lib/game_team'
require 'pry'
require 'csv'

class DummyGameTest < Minitest::Test

  def setup
    game_path = './data/game.csv'
    team_path = './data/team_info.csv'
    game_teams_path = './data/game_teams_stats.csv'
    dummy_game_path = './dummy_data/dummy_game.csv'
    dummy_team_path = './dummy_data/dummy_team_info.csv'
    dummy_game_teams_path = './dummy_data/dummy_game_team_stats.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path,
      dummy_games: dummy_game_path,
      dummy_teams: dummy_team_path,
      dummy_game_teams: dummy_game_teams_path
    }
    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_it_exist
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_attributes
    assert_instance_of Game, @stat_tracker.games["2012030221"]
  end

  def test_highest_total_score
    assert_equal 7, @stat_tracker.highest_total_score
  end


  def test_lowest_total_score
    assert_equal 1, @stat_tracker.lowest_total_score
  end

  def test_biggest_blowout
    assert_equal 5, @stat_tracker.biggest_blowout
  end

  def test_percentage_home_wins
    assert_equal 70.00, @stat_tracker.percentage_home_wins
  end

  def test_percentage_visitor_wins
    assert_equal 30.00, @stat_tracker.percentage_visitor_wins
  end

  def test_count_of_games_by_season
    expected = {"20122013" => 10}

    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

end
