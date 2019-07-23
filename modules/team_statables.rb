module TeamStatables
  
  def team_info(team_id)
    hash = Hash.new
    @teams[team_id].instance_variables.each do |var|
      hash[var.to_s.delete("@")] = @teams[team_id].instance_variable_get(var)
    end
    hash
  end

  def games_by_season(team_id)
    hash = Hash.new(0)
    all_seasons_array.each do |season|
      @games.values.each do |game|
        hash[season] += 1 if (game.away_team_id == team_id || game.home_team_id == team_id) && game.season == season
      end
    end
    hash
  end

  def wins_by_season(team_id)
    hash = Hash.new(0)
    all_seasons_array.each do |season|
      @games.values.each do |game|
        hash[season] += 1 if ((game.away_team_id == team_id && game.away_goals > game.home_goals) || (game.home_team_id == team_id && game.home_goals > game.away_goals)) && game.season == season
      end
    end
    hash
  end

  def worst_and_best_season(team_id)
    array = wins_by_season(team_id).merge(games_by_season(team_id)) { |season, wins, games| wins / games.to_f }
      .minmax_by { |season, win_pct| win_pct }
  end

  def best_season(team_id)
    worst_and_best_season(team_id)[1][0]
  end

  def worst_season(team_id)
    worst_and_best_season(team_id)[0][0]
  end

  def total_games(team_id)
    hash = Hash.new(0)
    @games.values.each do |game|
      hash[team_id] += 1 if game.away_team_id == team_id || game.home_team_id == team_id
    end
    hash
  end

  def total_wins(team_id)
    hash = Hash.new(0)
    @games.values.each do |game|
      hash[team_id] += 1 if (game.away_team_id == team_id && game.away_goals > game.home_goals) || (game.home_team_id == team_id && game.home_goals > game.away_goals)
    end
    hash
  end

  def average_win_percentage(team_id)
    hash = total_wins(team_id).merge(total_games(team_id)) { |team_id, wins, games| (wins / games.to_f).round(2) }
    hash[team_id]
  end

  def most_goals_scored(team_id)
    all_game_teams = @game_teams.values.find_all { |game_team| game_team.team_id == team_id }
    all_game_teams.max_by { |game_team| game_team.goals }.goals
  end

  def fewest_goals_scored(team_id)
    all_game_teams = @game_teams.values.find_all { |game_team| game_team.team_id == team_id }
    all_game_teams.min_by { |game_team| game_team.goals }.goals
  end

  def games_against_other_teams(team_id)
    hash = Hash.new(0)
    @teams.values.each do |team|
      @games.values.each do |game|
        hash[team.team_id] += 1 if (game.away_team_id == team_id && game.home_team_id == team.team_id) || (game.home_team_id == team_id && game.away_team_id == team.team_id)
      end
    end
    if hash[team_id] == 0
      hash.delete(team_id)
    end
    hash
  end

  def wins_against_other_teams(team_id)
    hash = Hash.new(0)
    @teams.values.each do |team|
      @games.values.each do |game|
        hash[team.team_id] += 1 if (game.away_team_id == team_id && game.home_team_id == team.team_id && game.away_goals > game.home_goals) || (game.home_team_id == team_id && game.away_team_id == team.team_id && game.home_goals > game.away_goals)
      end
    end
    hash
  end

  def favorite_opponent(team_id)
    array = wins_against_other_teams(team_id).merge(games_against_other_teams(team_id)) { |team_id, wins, games| wins / games.to_f }
      .max_by { |team_id, win_pct| win_pct }
    @teams[array[0]].team_name
  end

  def rival(team_id)
    array = wins_against_other_teams(team_id).merge(games_against_other_teams(team_id)) { |team_id, wins, games| wins / games.to_f }
      .min_by { |team_id, win_pct| win_pct }
    @teams[array[0]].team_name
  end

  def game_point_differential(team_id)
    array = []
    @games.values.each do |game|
      if game.away_team_id == team_id
        array << game.away_goals - game.home_goals
      elsif game.home_team_id == team_id
        array << game.home_goals - game.away_goals
      end
    end
    array
  end

  def biggest_team_blowout(team_id)
    game_point_differential(team_id).max
  end

  def worst_loss(team_id)
    game_point_differential(team_id).min.abs
  end

  def head_to_head(team_id)
    hash = wins_against_other_teams(team_id).merge(games_against_other_teams(team_id)) { |team_id, wins, games| (wins / games.to_f).round(2) }
    transformed_keys = Hash.new
    hash.keys.each do |team_id|
      transformed_keys[team_id] = @teams[team_id].team_name
    end
    hash.map { |team_id, win_pct| [transformed_keys[team_id], win_pct] }.to_h
  end

  def seasonal_summary(team_id)
    post_season_games = Hash.new(0)
    all_seasons_ary = []
    @games.values.map do |game|
      all_seasons_ary << game.season
    end
    all_seasons_ary.uniq.each do |season|
      post_season_games[season] = {postseason: Hash.new, regular_season: Hash.new}
    end
    post_season_games.each do |season, stats|
      post_season_games[season][:postseason][:win_percentage] = season_win_percentages_type(team_id, "P")[season]
      post_season_games[season][:postseason][:total_goals_scored] = goals_scored_per_season_type(team_id, "P")[season]
      post_season_games[season][:postseason][:total_goals_against] = goals_allowed_per_season_type(team_id, "P")[season]
      post_season_games[season][:postseason][:average_goals_scored] = average_goals_scored_season_type(team_id, "P")[season]
      post_season_games[season][:postseason][:average_goals_against] = average_goals_allowed_season_type(team_id, "P")[season]
      post_season_games[season][:regular_season][:win_percentage] = season_win_percentages_type(team_id, "R")[season]
      post_season_games[season][:regular_season][:total_goals_scored] = goals_scored_per_season_type(team_id, "R")[season]
      post_season_games[season][:regular_season][:total_goals_against] = goals_allowed_per_season_type(team_id, "R")[season]
      post_season_games[season][:regular_season][:average_goals_scored] = average_goals_scored_season_type(team_id, "R")[season]
      post_season_games[season][:regular_season][:average_goals_against] = average_goals_allowed_season_type(team_id, "R")[season]
    end
  end

  def games_per_season_type(team_id, post_reg)
    season_games = Hash.new(0)
    all_seasons_ary = []
    @games.values.map do |game|
      all_seasons_ary << game.season
    end
    all_seasons_ary.uniq.each do |season|
      season_games[season] = @games.values.count {|g| g.season == season && g.type == post_reg && (g.home_team_id == team_id || g.away_team_id == team_id)}
    end
    season_games
  end

  def games_won_per_season_type (team_id, post_reg)
    season_games = Hash.new(0)
    all_seasons_ary = []
    @games.values.map do |game|
      all_seasons_ary << game.season
    end
    all_seasons_ary.uniq.each do |season|
      season_games[season] << @games.values.count do |g|
        g.season == season && g.type == post_reg &&
        (g.home_team_id == team_id || g.away_team_id == team_id) &&
        if g.home_team_id == team_id &&
          g.home_goals > g.away_goals
          season_games[season] += 1
        elsif g.away_team_id == team_id &&
          g.away_goals > g.home_goals
          season_games[season] += 1
        end
      end
    end
    season_games
  end

  def season_win_percentages_type(team_id, post_reg)
    seazy = games_won_per_season_type(team_id, post_reg).merge(games_per_season_type(team_id, post_reg)) {|season, won, played| won / played.to_f}
    seazy.transform_values{|v| v.round(2)}
  end

  def goals_scored_per_season_type(team_id, post_reg)
    season_goals = Hash.new(0)
    all_seasons_ary = []
    @games.values.map do |game|
      all_seasons_ary << game.season
    end
    all_seasons_ary.uniq.each do |season|
      @games.values.each do |g|
        if g.season == season && g.type == post_reg &&
        g.home_team_id == team_id
        season_goals[season] += g.home_goals
      elsif g.season == season && g.type == post_reg &&
        g.away_team_id == team_id
        season_goals[season] += g.away_goals
        end
      end
    end
    season_goals
  end

  def goals_allowed_per_season_type(team_id, post_reg)
    season_goals = Hash.new(0)
    all_seasons_ary = []
    @games.values.map do |game|
      all_seasons_ary << game.season
    end
    all_seasons_ary.uniq.each do |season|
      @games.values.each do |g|
        if g.season == season && g.type == post_reg &&
        g.home_team_id == team_id
        season_goals[season] += g.away_goals
      elsif g.season == season && g.type == post_reg &&
        g.away_team_id == team_id
        season_goals[season] += g.home_goals
        end
      end
    end
    season_goals
  end

  def average_goals_scored_season_type(team_id, post_reg)
    stat = goals_scored_per_season_type(team_id, post_reg).merge(games_per_season_type(team_id, post_reg)) {|season, goals, games| goals / games.to_f}
    stat.transform_values{|v| v.round(2)}
  end

  def average_goals_allowed_season_type(team_id, post_reg)
    stat = goals_allowed_per_season_type(team_id, post_reg).merge(games_per_season_type(team_id, post_reg)) {|season, goals, games| goals / games.to_f}
    stat.transform_values{|v| v.round(2)}
  end
end 
