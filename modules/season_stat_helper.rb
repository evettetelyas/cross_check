module SeasonStatHelper

  def all_season_hash(team_id)
    all_games_won_by_season(team_id).merge(all_games_played_by_season(team_id)) {|season, won, played| won / played.to_f}
  end

  def all_seasons_ary
    all_seasons_ary = []
    @games.values.map do |game|
      all_seasons_ary << game.season
    end
    all_seasons_ary.uniq
  end

  def all_games_played_by_season(team_id)
    all_season_games = Hash.new
    all_seasons_ary.each do |season|
      all_season_games[season] = @games.values.count {|g| g.season == season && (g.home_team_id == team_id || g.away_team_id == team_id)}
    end
    all_season_games
  end

  def all_games_won_by_season(team_id)
    all_season_won_games = Hash.new
    all_seasons_ary.each do |season|
      all_season_won_games[season] = @games.values.count do |g| g.season == season &&
        (g.home_team_id == team_id || g.away_team_id == team_id) &&
        if g.home_team_id == team_id
          g.home_goals > g.away_goals
        elsif g.away_team_id == team_id
          g.away_goals > g.home_goals
        end
      end
    end
    all_season_won_games
  end

  def season_win_percentages_type(team_id, post_reg)
    seazy = games_won_per_season_type(team_id, post_reg).merge(games_per_season_type(team_id, post_reg)) {|season, won, played| won / played.to_f}
    seazy.transform_values{|v| v.round(2)}
  end

end
