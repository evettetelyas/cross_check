class Team
  attr_reader :team_id, :team_name, :abbreviation, :franchise_id, :short_name, :link

  def initialize(row)
    @team_id = row["team_id"]
    @team_name = row["teamName"]
    @short_name = row["shortName"]
    @abbreviation = row["abbreviation"]
    @franchise_id = row["franchiseId"]
    @link = row["link"]
  end

  def hashify
    instance_variables.map do |var|
      [var[1..-1], instance_variable_get(var)]
    end.to_h
  end

end
