module SeasonStatables
  def regular_season_games_by_team(season)
    hash = Hash.new(0)
    @teams.values.each do |team|
      @games.values.each do |game|
        if (game.away_team_id == team.team_id || game.home_team_id == team.team_id) && game.season == season && game.type == "R"
          hash[team.team_id] += 1
        end
      end
    end
    hash
  end

  def regular_season_wins_by_team(season)
    hash = Hash.new
    @teams.values.each do |team|
      hash[team.team_id] = 0
      @games.values.each do |game|
        if ((game.away_team_id == team.team_id && game.away_goals > game.home_goals) || (game.home_team_id == team.team_id && game.home_goals > game.away_goals)) && game.season == season && game.type == "R"
          hash[team.team_id] += 1
        end
      end
    end
    hash
  end

  def postseason_games_by_team(season)
    hash = Hash.new(0)
    @teams.values.each do |team|
      @games.values.each do |game|
        if (game.away_team_id == team.team_id || game.home_team_id == team.team_id) && game.season == season && game.type == "P"
          hash[team.team_id] += 1
        end
      end
    end
    hash
  end

  def postseason_wins_by_team(season)
    hash = Hash.new
    @teams.values.each do |team|
      hash[team.team_id] = 0
      @games.values.each do |game|
        if ((game.away_team_id == team.team_id && game.away_goals > game.home_goals) || (game.home_team_id == team.team_id && game.home_goals > game.away_goals)) && game.season == season && game.type == "P"
          hash[team.team_id] += 1
        end
      end
    end
    hash
  end

  def regular_season_win_percentage(season)
    regular_season_wins_by_team(season).merge(regular_season_games_by_team(season)) { |team_id, wins, games| wins / games.to_f }
  end

  def postseason_win_percentage(season)
    postseason_wins_by_team(season).merge(postseason_games_by_team(season)) { |team_id, wins, games| wins / games.to_f }
  end

  def biggest_bust(season)
    array = regular_season_win_percentage(season).merge(postseason_win_percentage(season)) { |team_id, reg_pct, post_pct| reg_pct - post_pct }
      .max_by { |team_id, diff| diff }
    @teams[array[0]].team_name
  end

  def biggest_surprise(season)
    array = regular_season_win_percentage(season).merge(postseason_win_percentage(season)) { |team_id, reg_pct, post_pct| reg_pct - post_pct }
      .min_by { |team_id, diff| diff }
    @teams[array[0]].team_name
  end

  def all_coaches_array
    array = []
    @game_teams.values.each do |game_team|
      array << game_team.head_coach
    end
    array.uniq
  end

  def games_by_coach(season)
    hash = Hash.new(0)
    all_coaches_array.each do |head_coach|
      @game_teams.values.each do |game_team|
        if @games[game_team.game_id].season == season && game_team.head_coach == head_coach
          hash[head_coach] += 1
        end
      end
    end
    hash
  end

  def wins_by_coach(season)
    hash = Hash.new
    all_coaches_array.each do |head_coach|
      hash[head_coach] = 0
      @game_teams.values.each do |game_team|
        if @games[game_team.game_id].season == season && game_team.head_coach == head_coach && game_team.won == "TRUE"
          hash[head_coach] += 1
        end
      end
    end
    hash
  end

  def winningest_coach(season)
    array = wins_by_coach(season).merge(games_by_coach(season)) { |head_coach, wins, games| wins / games.to_f }
      .max_by { |head_coach, win_pct| win_pct }
    array[0]
  end

  def worst_coach(season)
    array = wins_by_coach(season).merge(games_by_coach(season)) { |head_coach, wins, games| wins / games.to_f }
      .min_by { |head_coach, win_pct| win_pct }
    array[0]
  end

  def shots_by_team(season)
    hash = Hash.new(0)
    @teams.values.each do |team|
      @game_teams.values.each do |game_team|
        if @games[game_team.game_id].season == season && team.team_id == game_team.team_id
          hash[team.team_id] += game_team.shots
        end
      end
    end
    hash
  end

  def goals_by_team(season)
    hash = Hash.new(0)
    @teams.values.each do |team|
      @game_teams.values.each do |game_team|
        if @games[game_team.game_id].season == season && team.team_id == game_team.team_id
          hash[team.team_id] += game_team.goals
        end
      end
    end
    hash
  end

  def hits_by_team(season)
    hash = Hash.new(0)
    @teams.values.each do |team|
      @game_teams.values.each do |game_team|
        if @games[game_team.game_id].season == season && team.team_id == game_team.team_id
          hash[team.team_id] += game_team.hits
        end
      end
    end
    hash
  end

  def most_accurate_team(season)
    array = goals_by_team(season).merge(shots_by_team(season)) { |team_id, goals, shots| goals / shots.to_f }
      .max_by { |team_id, goal_ratio| goal_ratio }
    @teams[array[0]].team_name
  end

  def least_accurate_team(season)
    array = goals_by_team(season).merge(shots_by_team(season)) { |team_id, goals, shots| goals / shots.to_f }
      .min_by { |team_id, goal_ratio| goal_ratio }
    @teams[array[0]].team_name
  end

  def most_hits(season)
    array = hits_by_team(season).max_by { |team_id, hits| hits }
    @teams[array[0]].team_name
  end

  def fewest_hits(season)
    array = hits_by_team(season).min_by { |team_id, hits| hits }
    @teams[array[0]].team_name
  end

  def power_play_goals_by_season
    hash = Hash.new(0)
    all_seasons_array.each do |season|
      @game_teams.values.each do |game_team|
        if @games[game_team.game_id].season == season
          hash[season] += game_team.power_play_goals
        end
      end
    end
    @power_play_goals_by_season ||= hash
  end

  def goals_by_season
    hash = Hash.new(0)
    all_seasons_array.each do |season|
      @game_teams.values.each do |game_team|
        if @games[game_team.game_id].season == season
          hash[season] += game_team.goals
        end
      end
    end
    @goals_by_season ||= hash
  end

  def power_play_goal_percentage(season)
    hash = power_play_goals_by_season.merge(goals_by_season) { |season, ppg, goals| (ppg / goals.to_f ).round(2) }
    hash[season]
  end
end
