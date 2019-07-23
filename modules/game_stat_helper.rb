module GameStatHelper

  def confirm_opponent_at_home?(game, team_id, other_team_id)
    game.home_team_id == other_team_id && game.away_team_id == team_id
  end

  def confirm_opponent_away?(game, team_id, other_team_id)
    game.away_team_id == other_team_id && game.home_team_id == team_id
  end

  def confirm_home_team_won?(game)
    game.away_goals < game.home_goals
  end

  def confirm_away_team_won?(game)
    game.away_goals > game.home_goals
  end

  def games_per_season_type(team_id, post_reg)
    season_games = Hash.new(0)
    all_seasons_ary.each do |season|
      season_games[season] = @games.values.count {|g| g.season == season && g.type == post_reg && (g.home_team_id == team_id || g.away_team_id == team_id)}
    end
    season_games
  end

  def games_won_per_season_type (team_id, post_reg)
    season_games = Hash.new(0)
    all_seasons_ary.each do |season|
      season_games[season] << @games.values.count do |g|
        g.season == season && g.type == post_reg &&
        (g.home_team_id == team_id || g.away_team_id == team_id) &&
        if g.home_team_id == team_id &&
          confirm_home_team_won?(g)
          season_games[season] += 1
        elsif g.away_team_id == team_id &&
          confirm_away_team_won?(g)
          season_games[season] += 1
        end
      end
    end
    season_games
  end

  def all_game_goals(team_id)
    all_goals_by_game = Hash.new
    all_games_per_team(team_id).each do |game|
      if team_id == game.home_team_id
      all_goals_by_game[game] = game.home_goals
      elsif team_id == game.away_team_id
      all_goals_by_game[game] = game.away_goals
      end
    end
    all_goals_by_game
  end

  def goals_scored_per_season_type(team_id, post_reg)
    season_goals = Hash.new(0)
    all_seasons_ary.each do |season|
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
    all_seasons_ary.each do |season|
      @games.values.each do |g|
        if g.season == season && g.type == post_reg && g.home_team_id == team_id
        season_goals[season] += g.away_goals
      elsif g.season == season && g.type == post_reg && g.away_team_id == team_id
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
