require './test/test_helper'

class StatTrackerTest < Minitest::Test
  def setup
    game_path = './dummy_data/dummy_game.csv'
    team_path = './dummy_data/dummy_team_info.csv'
    game_teams_path = './dummy_data/dummy_game_team_stats.csv'

    @locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    @stat_tracker = StatTracker.from_csv(@locations)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_create_games
    binding.pry
    assert_instance_of Hash, StatTracker.create_games(@locations)
  end



end
