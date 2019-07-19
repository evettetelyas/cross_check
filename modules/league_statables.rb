module LeagueStatables

  def count_of_teams
    @teams.count
  end

# reused in total_games_by_team, lowest_and_highest_scoring_home_team
  def home_goals_by_team
    hash = Hash.new(0)
    @teams.values.each do |team|
      @games.values.each do |game|
        if game.home_team_id == team.team_id
          hash[team.team_id] += game.home_goals
        end
      end
    end
    @home_goals_by_team ||= hash
  end

# reused in total_goals_by_team, lowest_and_highest_scoring_visitor
  def away_goals_by_team
    hash = Hash.new(0)
    @teams.values.each do |team|
      @games.values.each do |game|
        if game.away_team_id == team.team_id
          hash[team.team_id] += game.away_goals
        end
      end
    end
    @away_goals_by_team ||= hash
  end

# reused in worst_and_best_offense
  def total_goals_by_team
    @total_goals_by_team ||= home_goals_by_team.merge(away_goals_by_team) { |team_id, home_goals, away_goals| home_goals + away_goals }
  end

# reused in worst_and_best_defense
  def total_goals_allowed_by_team
    hash = Hash.new(0)
    @teams.values.each do |team|
      @games.values.each do |game|
        if game.away_team_id == team.team_id
          hash[team.team_id] += game.home_goals
        elsif game.home_team_id == team.team_id
          hash[team.team_id] += game.away_goals
        end
      end
    end
    @total_goals_allowed_by_team ||= hash
  end

# reused in total_games_by_team, lowest_and_highest_scoring_home_team
  def home_games_by_team
    hash = Hash.new(0)
    @teams.values.each do |team|
      @games.values.each do |game|
        if game.home_team_id == team.team_id
          hash[team.team_id] += 1
        end
      end
    end
    @home_games_by_team ||= hash
  end

# reused in total_games_by_team, lowest_and_highest_scoring_visitor
  def away_games_by_team
    hash = Hash.new(0)
    @teams.values.each do |team|
      @games.values.each do |game|
        if game.away_team_id == team.team_id
          hash[team.team_id] += 1
        end
      end
    end
    @away_games_by_team ||= hash
  end

# reused in worst_and_best_offense, worst_and_best_defense, winningest_team
def total_games_by_team
  @total_games_by_team ||= home_games_by_team.merge(away_games_by_team) { |team_id, home_games, away_games| home_games + away_games }
end

# reused in best_offense, worst_offense
  def worst_and_best_offense
    array = total_games_by_team.merge(total_goals_by_team) { |team_id, games, goals| goals / games.to_f}
      .minmax_by { |team_id, goals_per_game| goals_per_game }
    @worst_and_best_offense ||= array
  end

  def best_offense
    @teams[worst_and_best_offense[1][0]].team_name
  end

  def worst_offense
    @teams[worst_and_best_offense[0][0]].team_name
  end

# reused in best_offense, worst_offense
  def best_and_worst_defense
    array = total_games_by_team.merge(total_goals_allowed_by_team) { |team_id, games, goals_allowed| goals_allowed / games.to_f }
      .minmax_by { |team_id, goals_allowed_per_game| goals_allowed_per_game }
    @best_and_worst_defense ||= array
  end

  def best_defense
    @teams[best_and_worst_defense[0][0]].team_name
  end

  def worst_defense
    @teams[best_and_worst_defense[1][0]].team_name
  end

# reused in highest_scoring_visitor, lowest_scoring_visitor
  def lowest_and_highest_scoring_visitor
    array = away_games_by_team.merge(away_goals_by_team) { |team_id, away_games, away_goals| away_goals / away_games.to_f }
      .minmax_by { |team_id, away_goals_per_game| away_goals_per_game }
    @lowest_and_highest_scoring_visitor ||= array
  end

  def highest_scoring_visitor
    @teams[lowest_and_highest_scoring_visitor[1][0]].team_name
  end

  def lowest_scoring_visitor
    @teams[lowest_and_highest_scoring_visitor[0][0]].team_name
  end

# reused in highest_scoring_home_team, lowest_scoring_home_team
  def lowest_and_highest_scoring_home_team
    array = home_games_by_team.merge(home_goals_by_team) { |team_id, home_games, home_goals| home_goals / home_games.to_f }
      .minmax_by { |team_id, home_goals_per_game| home_goals_per_game }
    @lowest_and_highest_scoring_home_team ||= array
  end

  def highest_scoring_home_team
    @teams[lowest_and_highest_scoring_home_team[1][0]].team_name
  end

  def lowest_scoring_home_team
    @teams[lowest_and_highest_scoring_home_team[0][0]].team_name
  end

# reused in total_wins_by_team
  def home_wins_by_team
    hash = Hash.new(0)
    @teams.values.each do |team|
      @games.values.each do |game|
        if game.home_team_id == team.team_id && game.home_goals > game.away_goals
          hash[team.team_id] += 1
        end
      end
    end
    @home_wins_by_team ||= hash
  end

# reused in total_wins_by_team
  def away_wins_by_team
    hash = Hash.new(0)
    @teams.values.each do |team|
      @games.values.each do |game|
        if game.away_team_id == team.team_id && game.home_goals < game.away_goals
          hash[team.team_id] += 1
        end
      end
    end
    @away_wins_by_team ||= hash
  end

# reused in winningest_team
  def total_wins_by_team
    @total_wins_by_team ||= home_wins_by_team.merge(away_wins_by_team) { |team_id, home_wins, away_wins| home_wins + away_wins }
  end

  def winningest_team
    array = total_wins_by_team.merge(total_games_by_team) { |team_id, total_wins, total_games| total_wins / total_games.to_f }
      .max_by { |team_id, total_win_pct| total_win_pct }
    @teams[array[0]].team_name
  end

# reused in best_fans, worst_fans
  def home_win_percentage_by_team
    @home_win_percentage_by_team ||= home_wins_by_team.merge(home_games_by_team) { |team_id, home_wins, home_games| home_wins / home_games.to_f }
  end

# reused in best_fans, worst_fans
  def away_win_percentage_by_team
    @away_win_percentage_by_team ||= away_wins_by_team.merge(away_games_by_team) { |team_id, away_wins, away_games| away_wins / away_games.to_f }
  end

  def best_fans
    array = home_win_percentage_by_team.merge(away_win_percentage_by_team) { |team_id, home_pct, away_pct| home_pct - away_pct }
      .max_by  { |team_id, win_pct_diff| win_pct_diff }
    @teams[array[0]].team_name
  end

  def worst_fans
    array = home_win_percentage_by_team.merge(away_win_percentage_by_team) { |team_id, home_pct, away_pct| home_pct - away_pct }
      .find_all  { |team_id, win_pct_diff| win_pct_diff < 0 }
    array.map { |array| @teams[array[0]].team_name }
  end
end
