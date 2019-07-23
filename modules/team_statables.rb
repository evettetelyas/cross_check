module TeamStatables

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

  def average_win_percentage(team_id)
    all_wins = all_games_won_by_season(team_id).values.sum
    all_games = all_games_played_by_season(team_id).values.sum
    avg = all_wins/all_games.to_f
    avg.round(2)
  end

  def most_goals_scored(team_id)
    most_goals_stat = all_game_goals(team_id).max_by {|k,v| v}
    most_goals_stat[1]
  end

  def fewest_goals_scored(team_id)
    fewest_goals_stat = all_game_goals(team_id).min_by {|k,v| v}
    fewest_goals_stat[1]
  end

  def favorite_opponent(team_id)
  percentages = opponent_games_won(team_id).merge(opponent_games_played(team_id)) {|opponent, lost, played| lost / played.to_f}
  worst = percentages.max_by {|k,v| v}
  @teams[worst[0]].team_name
  end

  def rival(team_id)
   percentages = opponent_games_lost(team_id).merge(opponent_games_played(team_id)) {|opponent, lost, played| lost / played.to_f}
   best = percentages.max_by {|k,v| v}
   @teams[best[0]].team_name
  end

  def biggest_team_blowout(team_id)
    biggest_team_blowout_hash(team_id).values.flatten.uniq.max
  end

  def worst_loss(team_id)
    biggest_team_loss_hash(team_id).values.flatten.uniq.max
  end

  def head_to_head(team_id)
   head_to_head_hash(team_id).transform_values {|v| (v[0]/v[1].to_f).round(2)}
  end

  def seasonal_summary(team_id)
    post_season_games = Hash.new(0)
    all_seasons_ary.each do |season|
      post_season_games[season] = {postseason: Hash.new(0), regular_season: Hash.new(0)}
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

end
