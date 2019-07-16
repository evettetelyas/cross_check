class Team
  attr_reader :team_id, :team_name, :abbreviation

  def initialize(row)
    @team_id = row["team_id"]
    @team_name = row["teamName"]
    @abbreviation = row["abbreviation"]
  end

end
