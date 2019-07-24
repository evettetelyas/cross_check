module SeasonStatables

  def biggest_bust(season)
    max = reg_post_szn_percentages(season)
      .max_by { |team, pct| pct }
    max[1].round(2)
    @teams[max[0]].team_name
  end

  def biggest_surprise(season)
    min = reg_post_szn_percentages(season)
      .min_by { |team, pct| pct }
    min[1].round(2)
    @teams[min[0]].team_name
  end

  def winningest_coach(season)
    max = games_vs_wins_by_coach(season)
      .max_by { |coach, pct| pct }
      max[1].round(2)
    max[0]
  end

  def worst_coach(season)
    min = games_vs_wins_by_coach(season)
      .min_by { |coach, pct| pct }
      min[1].round(2)
    min[0]
  end

  def most_accurate_team(season)
    max = goals_to_shots_by_team(season)
      .max_by { |team_id, goal_ratio| goal_ratio }
      max[1].round(2)
    @teams[max[0]].team_name
  end

  def least_accurate_team(season)
    min = goals_to_shots_by_team(season)
      .min_by { |team_id, goal_ratio| goal_ratio }
      min[1].round(2)
    @teams[min[0]].team_name
  end

  def most_hits(season)
    array = hits_by_team(season).max_by { |team_id, hits| hits }
    @teams[array[0]].team_name
  end

  def fewest_hits(season)
    array = hits_by_team(season).min_by { |team_id, hits| hits }
    @teams[array[0]].team_name
  end

  def power_play_goal_percentage(season)
    hash = goals_by_season_by_type.transform_values{|v| (v[0]/v[1].to_f).round(2)}
    hash[season]
  end

end
