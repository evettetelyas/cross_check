module TeamStatables
  include LeagueStatables

  def team_info(team_id)
    @teams[team_id].hashify
  end

  def best_season(team_id)
    best_season_stat = all_season_hash(team_id).max_by {|k,v| v}
    best_season_stat[0]
  end

  def worst_season(team_id)
    worst_season_stat = all_season_hash(team_id).min_by {|k,v| v}
    worst_season_stat[0]
  end

  def all_season_hash(team_id)
    all_games_won_by_season(team_id).merge(all_games_played_by_season(team_id)) {|season, won, played| won / played.to_f}
  end

  def all_games_played_by_season(team_id)
    all_season_games = Hash.new
    all_seasons_ary = []
    @games.values.map do |game|
      all_seasons_ary << game.season
    end
    all_seasons_ary.uniq.each do |season|
      all_season_games[season] = @games.values.count {|g| g.season == season && (g.home_team_id == team_id || g.away_team_id == team_id)}
    end
    all_season_games
  end

  def all_games_won_by_season(team_id)
    all_season_won_games = Hash.new
    all_seasons_ary = []
    @games.values.map do |game|
      all_seasons_ary << game.season
    end
    all_seasons_ary.uniq.each do |season|
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

end
