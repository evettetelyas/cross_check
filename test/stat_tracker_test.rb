require './test/test_helper'

class DummyGameTest < Minitest::Test

  def setup
    game_path = './dummy_data/dummy_game.csv'
    team_path = './dummy_data/dummy_team_info.csv'
    game_teams_path = './dummy_data/dummy_game_team_stats.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path,
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
    skip
    assert_equal 7, @stat_tracker.highest_total_score
  end


  def test_lowest_total_score
    skip
    assert_equal 1, @stat_tracker.lowest_total_score
  end

  def test_biggest_blowout
    skip
    assert_equal 5, @stat_tracker.biggest_blowout
  end

  def test_percentage_home_wins
    skip
    assert_equal 70.00, @stat_tracker.percentage_home_wins
  end

  def test_percentage_visitor_wins
    skip
    assert_equal 30.00, @stat_tracker.percentage_visitor_wins
  end

  def test_count_of_games_by_season
    skip
    expected = {"20122013" => 10}

    assert_equal expected, @stat_tracker.count_of_games_by_season
  end

  def test_average_goals_per_game
    skip
    assert_equal 4.5, @stat_tracker.average_goals_per_game
  end

end
