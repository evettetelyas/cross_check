module LeagueStatables

  #regular methods
  def count_of_teams
    @teams.count
  end

  def best_offense
    @teams.values.max_by { |value| average_goals_per_game_team(value.team_id) }
      .team_name
  end

  def worst_offense
    @teams.values.min_by { |value| average_goals_per_game_team(value.team_id) }
      .team_name
  end


  def best_defense
    @teams.values.min_by { |value| average_goals_allowed_per_game(value.team_id) }
      .team_name
  end

  def worst_defense
    @teams.values.max_by { |value| average_goals_allowed_per_game(value.team_id) }
      .team_name
  end

  def highest_scoring_visitor
    @teams.values.max_by { |value| average_away_goals(value.team_id) }
      .team_name
  end

  def highest_scoring_home_team
    @teams.values.max_by { |value| average_home_goals(value.team_id) }
      .team_name
  end

  def lowest_scoring_visitor
    @teams.values.min_by { |value| average_away_goals(value.team_id) }
      .team_name
  end

  def lowest_scoring_home_team
    @teams.values.min_by { |value| average_home_goals(value.team_id) }
      .team_name
  end

  def winningest_team
    @teams.values.max_by { |value| all_games_winning_percentage(value.team_id) }
      .team_name
  end

  def best_fans
    @teams.values.max_by { |value| home_game_win_percentage(value.team_id) - away_game_win_percentage(value.team_id) }
      .team_name
  end

  def worst_fans
    bad_fans = @teams.values.find_all { |value| home_game_win_percentage(value.team_id) < away_game_win_percentage(value.team_id) }
    bad_fans.map { |value| value.team_name }
  end

  #end regular methods







#------------------------------











  #helper methods below


  def game_teams_by_team(team_id)
    @game_teams.values.find_all { |value| value.team_id == team_id }
  end

  def total_goals(team_id)
    game_teams_by_team(team_id).sum { |game_team| game_team.goals }
  end

  def average_goals_per_game_team(team_id)
    (total_goals(team_id) / game_teams_by_team(team_id).size.to_f).round(2)
  end

  def games_by_team(team_id)
    @games.values.find_all do |value|
      value.away_team_id == team_id || value.home_team_id == team_id
    end
  end

  def home_games(team_id)
    games_by_team(team_id).find_all { |game| game.home_team_id == team_id }
  end

  def away_games(team_id)
    games_by_team(team_id).find_all { |game| game.away_team_id == team_id }
  end

  def home_goals_allowed(team_id)
    home_games(team_id).sum { |game| game.away_goals }
  end

  def away_goals_allowed(team_id)
    away_games(team_id).sum { |game| game.home_goals }
  end

  def total_goals_allowed(team_id)
    home_goals_allowed(team_id) + away_goals_allowed(team_id)
  end

  def average_goals_allowed_per_game(team_id)
    (total_goals_allowed(team_id) / games_by_team(team_id).size.to_f ).round(2)
  end


  def total_home_goals(team_id)
    home_games(team_id).sum { |game| game.home_goals }
  end

  def total_away_goals(team_id)
    away_games(team_id).sum { |game| game.away_goals }
  end

  def average_home_goals(team_id)
    (total_home_goals(team_id) / home_games(team_id).size.to_f ).round(2)
  end

  def average_away_goals(team_id)
    (total_away_goals(team_id) / away_games(team_id).size.to_f ).round(2)
  end

  def home_games_won(team_id)
    home_games(team_id).find_all { |game| game.home_goals > game.away_goals }
  end

  def away_games_won(team_id)
    away_games(team_id).find_all { |game| game.away_goals > game.home_goals }
  end

  def all_games_won(team_id)
    home_games_won(team_id) + away_games_won(team_id)
  end

  def home_game_win_percentage(team_id)
    (home_games_won(team_id).size / home_games(team_id).size.to_f).round(2)
  end

  def away_game_win_percentage(team_id)
    (away_games_won(team_id).size / away_games(team_id).size.to_f).round(2)
  end

  def all_games_winning_percentage(team_id)
    (all_games_won(team_id).size / games_by_team(team_id).size.to_f).round(2)
  end




end
