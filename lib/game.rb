class Game

  def initialize(row)
    @game_id = row[:game_id]
    @away_goals = row[:away_goals].to_i
    @home_goals = row[:home_goals].to_i
  end


end
