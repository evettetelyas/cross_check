module GameStatHelper

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
    empty_szns = Hash.new(0)
    all_seasons_ary.each do |season|
      empty_szns[season] = 0
    end
    new_hash = stat.merge(empty_szns) {|szn, stat_val, empty_val| stat_val - empty_val}
    new_hash.transform_values{|v| v.round(2)}
  end

  def average_goals_allowed_season_type(team_id, post_reg)
    stat = goals_allowed_per_season_type(team_id, post_reg).merge(games_per_season_type(team_id, post_reg)) {|season, goals, games| goals / games.to_f}
    empty_szns = Hash.new(0)
    all_seasons_ary.each do |season|
      empty_szns[season] = 0
    end
    new_hash = stat.merge(empty_szns) {|szn, stat_val, empty_val| stat_val - empty_val}
    new_hash.transform_values{|v| v.round(2)}
  end

end
