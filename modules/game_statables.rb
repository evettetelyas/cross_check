module GameStatables

  def highest_total_score
    all_goals = @games.map {|key,value| value.away_goals + value.home_goals}
    return all_goals.max
  end

end
