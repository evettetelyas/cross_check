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
    all_goals = @games.map {|key,value| (value.away_goals - value.home_goals).abs}
    return all_goals.max
  end

  def percentage_home_wins
    home_wins = @games.select {|key, value| value.home_goals > value.away_goals}
    percentage = (home_wins.count / @games.count.to_f)*100
    return percentage.round(2)
  end

  def percentage_visitor_wins
    visitor_wins = @games.select {|key, value| value.home_goals < value.away_goals}
    percentage = (visitor_wins.count / @games.count.to_f)*100
    return percentage.round(2)
  end

end
