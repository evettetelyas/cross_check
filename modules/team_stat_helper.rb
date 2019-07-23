module TeamStatHelper

  def team_name_ary
    team_name_ary = []
    @teams.values.each do |team|
      team_name_ary.push(team.team_name)
    end
    team_name_ary.uniq
  end

  def all_games_per_team(team_id)
    all_games = []
    @games.values.each do |game|
      if team_id == game.home_team_id || game.away_team_id
        all_games << game
      end
    end
  end

  def opponent_stats_hash
    opp_data = Hash.new(0)
    @teams.values.each do |team|
      opp_data[team.team_id] = 0
    end
    opp_data
  end

  def opponent_games_played(team_id)
    games_played = Hash.new(0)
    opponent_stats_hash.map do |other_team_id, num_games|
      @games.values.each do |g|
        if opponent_at_home?(g, team_id, other_team_id)
          games_played[g.home_team_id] += 1
        elsif opponent_away?(g, team_id, other_team_id)
          games_played[g.away_team_id] += 1
        elsif num_games == 0
          games_played.delete(team_id)
        end
      end
    end
    games_played
  end

  def opponent_games_lost(team_id)
    games_lost = Hash.new(0)
    opponent_stats_hash.each do |other_team_id, num_wins|
      @games.values.each do |g|
        if opponent_at_home?(g, team_id, other_team_id) && home_team_won?(g)
          games_lost[g.home_team_id] += 1
        elsif opponent_away?(g, team_id, other_team_id) && away_team_won?(g)
          games_lost[g.away_team_id] += 1
        end
      end
    end
    games_lost
  end

  def opponent_games_won(team_id)
    games_won = Hash.new(0)
    opponent_stats_hash.each do |other_team_id, num_wins|
      @games.values.each do |g|
        if opponent_at_home?(g, team_id, other_team_id) && away_team_won?(g)
          games_won[g.home_team_id] += 1
        elsif opponent_away?(g, team_id, other_team_id) && home_team_won?(g)
          games_won[g.away_team_id] += 1
        end
      end
    end
    games_won
  end

  def biggest_team_blowout_hash(team_id)
    opponent_blowout_stats = Hash.new(0)
    @teams.values.each do |team|
      opponent_blowout_stats[team.team_id] = []
    end
    opponent_blowout_stats.each do |other_team_id, blowout_abs|
      @games.values.each do |g|
        if opponent_at_home?(g, team_id, other_team_id) &&
          away_team_won?(g)
          opponent_blowout_stats[g.home_team_id] << (goal_diff_absolute(g))
        elsif opponent_away?(g, team_id, other_team_id) &&
          home_team_won?(g)
          opponent_blowout_stats[g.away_team_id] << (goal_diff_absolute(g))
        end
      end
    end
    opponent_blowout_stats
  end

  def biggest_team_loss_hash(team_id)
    opponent_blowout_stats = Hash.new(0)
    @teams.values.each do |team|
      opponent_blowout_stats[team.team_id] = []
    end
    opponent_blowout_stats.each do |other_team_id, blowout_abs|
      @games.values.each do |g|
        if opponent_at_home?(g, team_id, other_team_id) && home_team_won?(g)
          opponent_blowout_stats[g.home_team_id] << (goal_diff_absolute(g))
        elsif opponent_away?(g, team_id, other_team_id) && away_team_won?(g)
          opponent_blowout_stats[g.away_team_id] << (goal_diff_absolute(g))
        end
      end
    end
    opponent_blowout_stats
  end

  def head_to_head_hash(team_id)
    opponent_stats = Hash.new(0)
    team_name_ary.each do |team_name|
      opponent_stats[team_name] = [0,0] #[0]=wins, [1]=total games
    end
    opponent_stats.each do |other_team_name, num_wins|
      @games.values.each do |game|
        if @teams[game.home_team_id].team_name == other_team_name &&
          game.away_team_id == team_id &&
          away_team_won?(game)
          opponent_stats[@teams[game.home_team_id].team_name][0] += 1
        elsif @teams[game.away_team_id].team_name == other_team_name &&
          game.home_team_id == team_id &&
          home_team_won?(game)
          opponent_stats[@teams[game.away_team_id].team_name][0] += 1
        end
        if @teams[game.home_team_id].team_name == other_team_name &&
          game.away_team_id == team_id
          opponent_stats[@teams[game.home_team_id].team_name][1] += 1
        elsif @teams[game.away_team_id].team_name == other_team_name &&
          game.home_team_id == team_id
          opponent_stats[@teams[game.away_team_id].team_name][1] += 1
        end
      end
    end
    opponent_stats.each do |team_name, games|
      if games[1] == 0
        opponent_stats.delete(team_name)
      end
    end
    opponent_stats
  end

end
