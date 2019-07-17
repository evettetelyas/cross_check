class GameTeam
  attr_reader :game_id, :team_id, :hoa, :won, :head_coach, :goals, :shots, :hits, :power_play_goals

  def initialize(row)
    @game_id = row["game_id"]
    @team_id = row["team_id"]
    @hoa = row["HoA"]
    @won = row["won"]
    @head_coach = row["head_coach"]
    @goals = row["goals"].to_i
    @shots = row["shots"].to_i
    @hits = row["hits"].to_i
    @power_play_goals = row["powerPlayGoals"].to_i
  end

  def won?
    @won == "TRUE"
  end

end
