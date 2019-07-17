module GameStatables

  def highest_total_score
    all_goals = @games.map {|key,value| value.away_goals + value.home_goals}
    return all_goals.max
  end

  def lowest_total_score
    all_goals = @games.map {|key,value| value.away_goals + value.home_goals}
    return all_goals.min
  end

  def biggest_blowout
    all_goal_values = @games.map {|key,value| (value.away_goals - value.home_goals).abs}
    return all_goal_values.max
  end

  def percentage_home_wins
    home_wins = @games.select {|key, value| value.home_goals > value.away_goals}
    percentage = (home_wins.count / @games.count.to_f)
    return percentage.round(2)
  end

  def percentage_visitor_wins
    visitor_wins = @games.select {|key, value| value.home_goals < value.away_goals}
    percentage = (visitor_wins.count / @games.count.to_f)
    return percentage.round(2)
  end

  def count_of_games_by_season
    games_per_season = Hash.new(0)
    @games.each do |key, value|
      games_per_season[value.season] += 1
    end
    games_per_season
  end

  def average_goals_per_game
    all_goals = @games.map {|key,value| value.away_goals + value.home_goals}
    (all_goals.sum.to_f / @games.count).round(2)
  end

  def average_goals_by_season
    avg_goals_by_season = Hash.new(0)
    @games.values.each {|value| avg_goals_by_season[value.season] += value.home_goals.to_i + value.away_goals.to_i}

    count_of_games_by_season.each{|season, count| avg_goals_by_season[season] = (avg_goals_by_season[season] / count.to_f).round(2)}
    
    avg_goals_by_season
  end

end
