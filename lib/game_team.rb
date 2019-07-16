class GameTeam
  attr_reader :game_id, :team_id, :hoa, :won, :head_coach, :goals, :shots, :hits, :power_play_goals

  def initialize(row)
    @game_id = row["game_id"]
    @team_id = row["team_id"]
    @hoa = row["HoA"]
    @won = row["won"]
    @head_coach = row["head_coach"]
    @goals = row["goals"]
    @shots = row["shots"]
    @hits = row["hits"]
    @power_play_goals = row["powerPlayGoals"]
  end

end
