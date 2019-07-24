module StatTrackerHelper

  def team_name_ary
    team_name_ary = []
    @teams.values.each do |team|
      team_name_ary.push(team.team_name)
    end
    team_name_ary.uniq
  end

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

  def opponent_at_home?(game, team_id, other_team_id)
    game.home_team_id == other_team_id && game.away_team_id == team_id
  end

  def opponent_away?(game, team_id, other_team_id)
    game.away_team_id == other_team_id && game.home_team_id == team_id
  end

  def home_team_won?(game)
    game.away_goals < game.home_goals
  end

  def away_team_won?(game)
    game.away_goals > game.home_goals
  end

  def goal_diff_absolute(game)
    game.home_goals - game.away_goals.abs
  end

  def all_games_per_team(team_id)
    all_games = []
    @games.values.each do |game|
      if team_id == game.home_team_id || game.away_team_id
        all_games << game
      end
    end
  end

  def opponent_stats_hash
    opp_data = Hash.new(0)
    @teams.values.each do |team|
      opp_data[team.team_id] = 0
    end
    opp_data
  end
end
