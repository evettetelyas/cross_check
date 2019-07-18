module SeasonStatables

  def regular_season_games_by_team(team_id, season)
    @games.values.find_all do |value|
      value.season == season &&
      value.type == "R" &&
      (value.away_team_id == team_id || value.home_team_id == team_id)
    end
  end

  def postseason_games_by_team(team_id, season)
    @games.values.find_all do |value|
      value.season == season &&
      value.type == "P" &&
      (value.away_team_id == team_id || value.home_team_id == team_id)
    end
  end

  def season_games_by_team(team_id, season)
    @games.values.find_all do |value|
      value.season == season &&
      (value.away_team_id == team_id || value.home_team_id == team_id)
    end
  end

  def regular_season_wins_by_team(team_id, season)
    regular_season_games_by_team(team_id, season).find_all do |game|
      if game.away_team_id == team_id
        game.away_goals > game.home_goals
      elsif game.home_team_id == team_id
        game.home_goals > game.away_goals
      end
    end
  end

  def postseason_wins_by_team(team_id, season)
    postseason_games_by_team(team_id, season).find_all do |game|
      if game.away_team_id == team_id
        game.away_goals > game.home_goals
      elsif game.home_team_id == team_id
        game.home_goals > game.away_goals
      end
    end
  end

  def season_wins_by_team(team_id, season)
    season_games_by_team(team_id, season).find_all do |game|
      if game.away_team_id == team_id
        game.away_goals > game.home_goals
      elsif game.home_team_id == team_id
        game.home_goals > game.away_goals
      end
    end
  end

  def regular_season_win_percentage(team_id, season)
    (regular_season_wins_by_team(team_id, season).size /
      regular_season_games_by_team(team_id, season).size.to_f).round(2)
  end

  def postseason_win_percentage(team_id, season)
    if postseason_games_by_team(team_id, season) == []
      regular_season_win_percentage(team_id, season)
    else
      (postseason_wins_by_team(team_id, season).size /
        postseason_games_by_team(team_id, season).size.to_f).round(2)
    end
  end

  def season_win_percentage(team_id, season)
    (season_wins_by_team(team_id, season).size /
      season_games_by_team(team_id, season).size.to_f).round(2)
  end

  def all_season_games(season)
    @games.values.find_all { |value| value.season == season }
  end

  def postseason_games(season)
    @games.values.find_all { |value| value.season == season && value.type == "P" }
  end

  def teams_that_made_the_postseason(season)
    home = postseason_games(season).map { |game| game.home_team_id }
    away = postseason_games(season).map { |game| game.away_team_id }
    all_ids = home + away
    all_ids.uniq!
    all_ids.map { |team_id| @teams[team_id] }
  end

  def biggest_bust(season)
    teams_that_made_the_postseason(season).max_by do |value|
      regular_season_win_percentage(value.team_id, season) -
      postseason_win_percentage(value.team_id, season)
    end.team_name
  end

  def biggest_surprise(season)
    teams_that_made_the_postseason(season).max_by do |value|
      postseason_win_percentage(value.team_id, season) -
      regular_season_win_percentage(value.team_id, season)
    end.team_name
  end


  # winningest_coach	Name of the Coach with the best win percentage for the season	String
  # worst_coach	Name of the Coach with the worst win percentage for the season	String
  # most_accurate_team	Name of the Team with the best ratio of shots to goals for the season	String
  # least_accurate_team	Name of the Team with the worst ratio of shots to goals for the season	String
  # most_hits	Name of the Team with the most hits in the season	String
  # fewest_hits	Name of the Team with the fewest hits in the season	String
  # power_play_goal_percentage	Percentage of goals that were power play goals for the season (rounded to the nearest 100th)	Float



end
