module GameStatables

  def highest_total_score
    highest_score = 0
    @games.values.each do |game|
      game_total = game.away_goals + game.home_goals
      highest_score = game_total if game_total > highest_score
    end
    highest_score
  end

  def lowest_total_score
    lowest_score = 5
    @games.values.each do |game|
      game_total = game.away_goals + game.home_goals
      lowest_score = game_total if game_total < lowest_score
    end
    lowest_score
  end

  def biggest_blowout
    diff = 0
    @games.values.each do |game|
      game_difference = (game.away_goals - game.home_goals).abs
      diff = game_difference if game_difference > diff
    end
    diff
  end

  def percentage_home_wins
    home_wins = @games.values.find_all do |game|
      game.home_goals > game.away_goals
    end
    (home_wins.size / @games.size.to_f).round(2)
  end

  def percentage_visitor_wins
    visitor_wins = @games.values.find_all do |game|
      game.home_goals < game.away_goals
    end
    (visitor_wins.size / @games.size.to_f).round(2)
  end

# reused in count_of_games_by_season, count_of_goals_by_season
  def all_seasons_array
    seasons = []
    @games.values.each do |game|
      seasons << game.season
    end
    @all_seasons_array ||= seasons.uniq!
  end

# reused in average_goals_by_season
  def count_of_games_by_season
    hash = Hash.new(0)
    all_seasons_array.each do |season|
      @games.values.each do |game|
        hash[season] += 1 if game.season == season
      end
    end
    @count_of_games_by_season ||= hash
  end

  def average_goals_per_game
    total_goals = @games.values.sum { |game| game.away_goals + game.home_goals }
    (total_goals / @games.size.to_f).round(2)
  end

# reused in average_goals_by_season
  def count_of_goals_by_season
    hash = Hash.new(0)
    all_seasons_array.each do |season|
      @games.values.each do |game|
        hash[season] += (game.away_goals + game.home_goals) if game.season == season
      end
    end
    @count_of_goals_by_season ||= hash
  end

  def average_goals_by_season
    hash = Hash.new
    all_seasons_array.each do |season|
      hash[season] = (count_of_goals_by_season[season] / count_of_games_by_season[season].to_f).round(2)
    end
    hash
  end
end
