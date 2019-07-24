module SeasonStatHelper

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

  def games_per_season_type(team_id, post_reg, all_games = false)
    season_games = Hash.new(0)
    all_seasons_ary.each do |season|
      season_games[season] = @games.values.count {|g| g.season == season && g.type == post_reg && (g.home_team_id == team_id || g.away_team_id == team_id)}
    end
      season_games.each do |season, games|
        season_games.delete(season) if games == 0
      end
  season_games
  end

  def games_won_per_season_type (team_id, post_reg)
    season_games = Hash.new(0)
    all_seasons_ary.each do |season|
      season_games[season] = 0
      @games.values.each do |g|
        g.season == season && g.type == post_reg &&
        (g.home_team_id == team_id || g.away_team_id == team_id) &&
        if g.home_team_id == team_id &&
          home_team_won?(g)
          season_games[season] += 1
        elsif g.away_team_id == team_id &&
          away_team_won?(g)
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

  def regular_season_win_percentage(season)
    reg_szn_wins = Hash.new
    @teams.values.each do |team|
      reg_szn_wins[team.team_id] = season_win_percentages_type(team.team_id, "R")[season]
    end
    reg_szn_wins
  end

  def postseason_win_percentage(season)
    post_szn_wins = Hash.new
    @teams.values.each do |team|
      post_szn_wins[team.team_id] = season_win_percentages_type(team.team_id, "P")[season]
    end
    post_szn_wins
  end

  def bust_surprise_minmax(season)
   regular_season_win_percentage(season).merge(postseason_win_percentage(season)) { |team_id, reg_pct, post_pct| reg_pct - post_pct }
      .minmax_by { |team_id, diff| diff }
  end

  def all_coaches_array(season)
    array = []
    @game_teams.values.each do |game_team|
      if @games[game_team.game_id].season == season
        array << game_team.head_coach
      end
    end
    array.uniq
  end

  def games_vs_wins_by_coach(season)
    hash = Hash.new {|h,k| h[k] = [0,0]}
    all_coaches_array(season).each do |head_coach|
      @game_teams.values.each do |game_team|
        if @games[game_team.game_id].season == season && game_team.head_coach == head_coach
          hash[head_coach][1] += 1
        end
        if @games[game_team.game_id].season == season && game_team.head_coach == head_coach && game_team.won?
          hash[head_coach][0] += 1
        end
      end
    end
    hash.transform_values{|v| (v[0]/v[1].to_f)}
  end

  def goals_to_shots_by_team(season)
    hash = Hash.new {|h,k| h[k] = [0,0]}
    @teams.values.each do |team|
      @game_teams.values.each do |game_team|
        if @games[game_team.game_id].season == season && team.team_id == game_team.team_id
          hash[team.team_id][0] += game_team.goals
          hash[team.team_id][1] += game_team.shots
        end
      end
    end
    hash.transform_values{|v| (v[0]/v[1].to_f)}
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

  def goals_by_season_by_type
    hash = Hash.new {|h,k| h[k] = [0,0]}
    all_seasons_ary.each do |season|
      @game_teams.values.each do |game_team|
        if @games[game_team.game_id].season == season
          hash[season][0] += game_team.power_play_goals
          hash[season][1] += game_team.goals
        end
      end
    end
    hash
  end

end
