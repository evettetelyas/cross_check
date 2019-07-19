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

  #Stat Tracker Tests
  def test_it_exist
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_attributes
    assert_instance_of Game, @stat_tracker.games["2014030135"]
    assert_instance_of GameTeam, @stat_tracker.game_teams[4]
  end
  #End Stat Tracker Tests










#ITERATION 2 GAME STATABLES MODULE TESTS
  def test_highest_total_score
     assert_equal 9, @stat_tracker.highest_total_score
  end

 def test_lowest_total_score
   assert_equal 3, @stat_tracker.lowest_total_score
 end

 def test_biggest_blowout
   assert_equal 3, @stat_tracker.biggest_blowout
 end

 def test_percentage_home_wins
   assert_equal 0.5, @stat_tracker.percentage_home_wins
 end

 def test_percentage_visitor_wins
   assert_equal 0.5, @stat_tracker.percentage_visitor_wins
 end

 def test_count_of_games_by_season
   expected = {"20142015" => 5, "20122013" => 5}
   assert_equal expected, @stat_tracker.count_of_games_by_season
 end

 def test_average_goals_per_game
   assert_equal 4.7, @stat_tracker.average_goals_per_game
 end

 def test_average_goals_per_season
   expected = {"20142015" => 4.4, "20122013" => 5.0}
   assert_equal expected, @stat_tracker.average_goals_by_season
 end
#END ITERATION 2 GAME STATS  METHOD TESTS











#ITERATION 3 LEAGUE STATABLES MODULE TESTS
def test_team_count
  assert_equal 3, @stat_tracker.count_of_teams
end

def test_best_offense
  assert_equal "Bruins", @stat_tracker.best_offense
end

def test_worst_offense
  assert_equal "Rangers", @stat_tracker.worst_offense
end

def test_best_defense
  assert_equal "Penguins", @stat_tracker.best_defense
end

def test_worst_defense
  assert_equal "Rangers", @stat_tracker.worst_defense
end

def test_highest_scoring_visitor
  assert_equal "Penguins", @stat_tracker.highest_scoring_visitor
end

def test_highest_scoring_home_team
  assert_equal "Bruins", @stat_tracker.highest_scoring_home_team
end

def test_lowest_scoring_visitor
  assert_equal "Bruins", @stat_tracker.lowest_scoring_visitor
end

def test_lowest_scoring_home_team
  assert_equal "Rangers", @stat_tracker.lowest_scoring_home_team
end

def test_winningest_team
  assert_equal "Penguins", @stat_tracker.winningest_team
end

def test_best_fans
  assert_equal "Penguins", @stat_tracker.best_fans
end

def test_worst_fans
  assert_equal ["Rangers"], @stat_tracker.worst_fans
end

##helper methods inside league statables
def test_game_team_by_team
  assert_equal 6, @stat_tracker.game_teams_by_team("6").count
end

def test_total_goals
  assert_equal 14, @stat_tracker.total_goals("6")
end

def test_average_goals_per_game_team
  assert_equal 2.33, @stat_tracker.average_goals_per_game_team("6")
end

def test_games_by_team
  assert_equal 6, @stat_tracker.games_by_team("6").count
end

def test_home_games
  assert_equal 4, @stat_tracker.home_games("6").count
end

def test_away_games
  assert_equal 2, @stat_tracker.away_games("6").count
end

def test_home_goals_allowed
  assert_equal 10, @stat_tracker.home_goals_allowed("6")
end

def test_away_goals_allowed
  assert_equal 3, @stat_tracker.away_goals_allowed("6")
end

def test_total_goals_allowed
  assert_equal 13, @stat_tracker.total_goals_allowed("6")
end

def average_total_goals_allowed
  assert_equal 2.17, @stat_tracker.average_goals_allowed("6")
end

def test_total_home_goals
  assert_equal 11, @stat_tracker.total_home_goals("6")
end

def test_total_away_goals
  assert_equal 3, @stat_tracker.total_away_goals("6")
end

def test_average_away_goals
  assert_equal 1.5, @stat_tracker.average_away_goals("6")
end

def test_average_home_goals
  assert_equal 2.75, @stat_tracker.average_home_goals("6")
end

def test_home_games_won
  assert_instance_of Array, @stat_tracker.home_games_won("6")
  assert_instance_of Game, @stat_tracker.home_games_won("6")[0]
  assert_equal 2, @stat_tracker.home_games_won("6").size
end

def test_away_games_won
  assert_instance_of Array, @stat_tracker.away_games_won("6")
  assert_instance_of Game, @stat_tracker.away_games_won("6")[0]
  assert_equal 1, @stat_tracker.away_games_won("6").size
end

def test_all_games_won
  assert_instance_of Array, @stat_tracker.all_games_won("6")
  assert_instance_of Game, @stat_tracker.all_games_won("6")[0]
  assert_equal 3, @stat_tracker.all_games_won("6").size
end

def test_home_game_win_percentage
  assert_equal 0.5, @stat_tracker.home_game_win_percentage("6")
end

def test_away_game_win_percentage
  assert_equal 0.5, @stat_tracker.away_game_win_percentage("6")
end

def test_all_games_win_percentage
  assert_equal 0.57, @stat_tracker.all_games_winning_percentage("5")
end

#END ITERATION 3 LEAGUE STATABLES  MODULES TESTS














#ITERATION 4 TEAM STATABLES MODULES TESTS
def test_team_info
  assert_instance_of Hash, @stat_tracker.team_info("6")
end

def test_best_season
  assert_equal "20142015", @stat_tracker.best_season("3")
end

def test_worst_season
  assert_equal "20122013", @stat_tracker.worst_season("3")
end

def test_average_win_percentage
  assert_equal 0.54, @stat_tracker.average_win_percentage("3")
end

def test_most_goals_scored
  assert_equal 8, @stat_tracker.most_goals_scored("3")
end

def test_fewest_goals_scored
  assert_equal 0, @stat_tracker.fewest_goals_scored("3")
end

def test_favorite_opponent
  assert_equal "Coyotes", @stat_tracker.favorite_opponent("3")
end

def test_rival
  assert_equal "Islanders", @stat_tracker.rival("3")
end

def test_biggest_team_blowout
  assert_equal 6, @stat_tracker.biggest_team_blowout("3")
  assert_equal 7, @stat_tracker.biggest_team_blowout("4")
  assert_equal 7, @stat_tracker.biggest_team_blowout("2")
end

def test_worst_loss
  assert_equal 7, @stat_tracker.worst_loss("3")
end

#STILL NEED HEAD_TO_HEAD AND SEASONAL_SUMMARY
#END ITERATION 4 TEAM STATABLES MODULE TESTS










#ITERATION 5 SEASON STATABLES MODULE TESTS
def test_biggest_bust
  assert_equal "Penguins", @stat_tracker.biggest_bust("20122013")
end

def test_biggest_surprise
  assert_equal "Bruins", @stat_tracker.biggest_surprise("20122013")
end

def test_winningest_coach

end


##helper methods inside season statables
def test_regular_season_games_by_team
  assert_instance_of Game, @stat_tracker.regular_season_games_by_team("6", "20142015").first
  assert_equal 2, @stat_tracker.regular_season_games_by_team("6", "20142015").size
end

def test_postseason_games_by_team
  assert_instance_of Game, @stat_tracker.postseason_games_by_team("3", "20142015").first
  assert_equal 2, @stat_tracker.postseason_games_by_team("3", "20142015").size
end

def test_season_games_by_team
  assert_instance_of Game, @stat_tracker.season_games_by_team("3", "20122013").first
  assert_equal 3, @stat_tracker.season_games_by_team("3", "20122013").size
end

def test_regular_season_wins_by_team
  assert_instance_of Game, @stat_tracker.regular_season_wins_by_team("5", "20122013").first
  assert_equal 2, @stat_tracker.regular_season_wins_by_team("5", "20122013").size
end

def test_postseason_wins_by_team
  assert_instance_of Game, @stat_tracker.postseason_wins_by_team("3", "20142015").first
  assert_equal 2, @stat_tracker.postseason_wins_by_team("3", "20142015").size
end

def test_season_wins_by_team
  assert_instance_of Game, @stat_tracker.season_wins_by_team("3", "20122013").first
  assert_equal 1, @stat_tracker.season_wins_by_team("3", "20122013").size
end

def test_regular_season_win_percentage
  assert_equal 0.5, @stat_tracker.regular_season_win_percentage("3", "20122013")
end

def test_postseason_win_percentage
  assert_equal 1.0, @stat_tracker.postseason_win_percentage("6", "20122013")
end


  def test_postseason_win_percentage
    assert_equal 0.33, @stat_tracker.season_win_percentage("3", "20122013")
  end

  def test_all_season_games
    assert_instance_of Game, @stat_tracker.all_season_games("20122013").first
    assert_equal 5, @stat_tracker.all_season_games("20122013").size
  end

  def test_postseason_games
    assert_instance_of Game, @stat_tracker.postseason_games("20122013").first
    assert_equal 2, @stat_tracker.postseason_games("20122013").size
  end

  def test_teams_that_made_the_postseason
    assert_equal 2, @stat_tracker.teams_that_made_the_postseason("20142015").size
  end

#END ITERATION 5 TEAM STATS MODULE TESTS



#ITERATION 1 GAME STATABLES HELPER METHOD TESTS
#END ITERATION 1 GAME STATABLES HELP METHOD TESTS



#GAME-TEAM.rb class METHODS
def test_won
  assert @stat_tracker.game_teams[4].won?
end
#END GAME

end
