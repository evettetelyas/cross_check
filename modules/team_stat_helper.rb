module TeamStatHelper

  def all_season_hash(team_id)
    all_games_won_by_season(team_id).merge(all_games_played_by_season(team_id)) {|season, won, played| won / played.to_f}
  end

  def all_games_played_by_season(team_id)
    all_season_games = Hash.new
    all_seasons_ary.each do |season|
      all_season_games[season] = @games.values.count {|g| g.season == season && (g.home_team_id == team_id || g.away_team_id == team_id)}
    end
    all_season_games
  end

  def all_games_won_by_season(team_id)
    all_season_won_games = Hash.new
    all_seasons_ary.each do |season|
      all_season_won_games[season] = @games.values.count do |g| g.season == season &&
        (g.home_team_id == team_id || g.away_team_id == team_id) &&
        if g.home_team_id == team_id
          g.home_goals > g.away_goals
        elsif g.away_team_id == team_id
          g.away_goals > g.home_goals
        end
      end
    end
    all_season_won_games
  end

  def all_games_per_team(team_id)
    all_games = []
    @games.values.each do |game|
      if team_id == game.home_team_id || game.away_team_id
        all_games << game
      end
    end
  end

  def all_game_goals(team_id)
    all_goals_by_game = Hash.new
    all_games_per_team(team_id).each do |game|
      if team_id == game.home_team_id
      all_goals_by_game[game] = game.home_goals
      elsif team_id == game.away_team_id
      all_goals_by_game[game] = game.away_goals
      end
    end
    all_goals_by_game
  end

  def opponent_stats_hash
    opp_data = Hash.new(0)
    @teams.values.each do |team|
      opp_data[team.team_id] = 0
    end
    opp_data
  end

  def confirm_opponent_at_home?(game, team_id, other_team_id)
    game.home_team_id == other_team_id && game.away_team_id == team_id
  end

  def confirm_opponent_away?(game, team_id, other_team_id)
    game.away_team_id == other_team_id && game.home_team_id == team_id
  end

  def confirm_home_team_won?(game)
    game.away_goals < game.home_goals
  end

  def confirm_away_team_won?(game)
    game.away_goals > game.home_goals
  end

  def opponent_games_played(team_id)
    games_played = Hash.new(0)
    opponent_stats_hash.map do |other_team_id, num_games|
      @games.values.each do |g|
        if confirm_opponent_at_home?(g, team_id, other_team_id)
          games_played[g.home_team_id] += 1
        elsif confirm_opponent_away?(g, team_id, other_team_id)
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
        if confirm_opponent_at_home?(g, team_id, other_team_id) && confirm_home_team_won?(g)
          games_lost[g.home_team_id] += 1
        elsif confirm_opponent_away?(g, team_id, other_team_id) && confirm_away_team_won?(g)
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
        if confirm_opponent_at_home?(g, team_id, other_team_id) && confirm_away_team_won?(g)
          games_won[g.home_team_id] += 1
        elsif confirm_opponent_away?(g, team_id, other_team_id) && confirm_home_team_won?(g)
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
        if confirm_opponent_at_home?(g, team_id, other_team_id) &&
          confirm_away_team_won?(g)
          opponent_blowout_stats[g.home_team_id] << ((g.home_goals - g.away_goals).abs)
        elsif confirm_opponent_away?(g, team_id, other_team_id) &&
          confirm_home_team_won?(g)
          opponent_blowout_stats[g.away_team_id] << ((g.home_goals - g.away_goals).abs)
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
        if confirm_opponent_at_home?(g, team_id, other_team_id) && confirm_home_team_won?(g)
          opponent_blowout_stats[g.home_team_id] << ((g.home_goals - g.away_goals).abs)
        elsif confirm_opponent_away?(g, team_id, other_team_id) && confirm_away_team_won?(g)
          opponent_blowout_stats[g.away_team_id] << ((g.home_goals - g.away_goals).abs)
        end
      end
    end
    opponent_blowout_stats
  end

  def team_name_ary
    team_name_ary = []
    @teams.values.each do |team|
      team_name_ary.push(team.team_name)
    end
    team_name_ary.uniq
  end

  def all_seasons_ary
    all_seasons_ary = []
    @games.values.map do |game|
      all_seasons_ary << game.season
    end
    all_seasons_ary.uniq
  end

  # def coyote_data(team_id)
  #   coyote_stats = [0,0] #[0] = games won, [1] = total games
  #   @games.values.each do |game|
  #     if @teams[game.home_team_id].franchise_id == "28" &&
  #       game.away_team_id == team_id &&
  #       game.away_goals > game.home_goals
  #       coyote_stats[0] += 1
  #     elsif @teams[game.away_team_id].franchise_id == "28" &&
  #       game.home_team_id == team_id &&
  #       game.away_goals < game.home_goals
  #       coyote_stats[0] += 1
  #     end
  #     if @teams[game.home_team_id].franchise_id == "28" &&
  #       game.away_team_id == team_id
  #       coyote_stats[1] += 1
  #     elsif @teams[game.away_team_id].franchise_id == "28" &&
  #       game.home_team_id == team_id
  #       coyote_stats[1] += 1
  #     end
  #   end
  #   coyote_stats
  # end
  #
  # def all_53_coyote_games_against_18
  #   coyote_games = [0,0] #[0] = wins, [1] = all games
  #   @games.values.each do |game|
  #     if (game.home_team_id == "53" && game.away_team_id == "18") || (game.away_team_id == "53" && game.home_team_id == "18")
  #       coyote_games[1] += 1
  #     end
  #     if (game.home_team_id == "53" && game.away_team_id == "18" && game.away_goals > game.home_goals) || (game.away_team_id == "53" && game.home_team_id == "18" && game.home_goals > game.away_goals)
  #       coyote_games[0] += 1
  #     end
  #   end
  #   coyote_games
  #   # (coyote_games[0]/coyote_games[1].to_f).round(2) = .67
  # end
  #
  # def all_27_coyote_games_against_18
  #   coyote_games = [0,0] #[0] = wins, [1] = all games
  #   @games.values.each do |game|
  #     if (game.home_team_id == "27" && game.away_team_id == "18") || (game.away_team_id == "27" && game.home_team_id == "18")
  #       coyote_games[1] += 1
  #     end
  #     if (game.home_team_id == "27" && game.away_team_id == "18" && game.away_goals > game.home_goals) || (game.away_team_id == "27" && game.home_team_id == "18" && game.home_goals > game.away_goals)
  #       coyote_games[0] += 1
  #     end
  #   end
  #   coyote_games
  # end

  def head_to_head_hash(team_id)
    opponent_stats = Hash.new(0)
    team_name_ary.each do |team_name|
      opponent_stats[team_name] = [0,0] #[0]=wins, [1]=total games
    end
    opponent_stats.each do |other_team_name, num_wins|
      @games.values.each do |game|
        if @teams[game.home_team_id].team_name == other_team_name &&
          game.away_team_id == team_id &&
          confirm_away_team_won?(game)
          opponent_stats[@teams[game.home_team_id].team_name][0] += 1
        elsif @teams[game.away_team_id].team_name == other_team_name &&
          game.home_team_id == team_id &&
          confirm_home_team_won?(game)
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

  def games_per_season_type(team_id, post_reg)
    season_games = Hash.new(0)
    all_seasons_ary.each do |season|
      season_games[season] = @games.values.count {|g| g.season == season && g.type == post_reg && (g.home_team_id == team_id || g.away_team_id == team_id)}
    end
    season_games
  end

  def games_won_per_season_type (team_id, post_reg)
    season_games = Hash.new(0)
    all_seasons_ary.each do |season|
      season_games[season] << @games.values.count do |g|
        g.season == season && g.type == post_reg &&
        (g.home_team_id == team_id || g.away_team_id == team_id) &&
        if g.home_team_id == team_id &&
          confirm_home_team_won?(g)
          season_games[season] += 1
        elsif g.away_team_id == team_id &&
          confirm_away_team_won?(g)
          season_games[season] += 1
        end
      end
    end
    season_games
  end

  def season_win_percentages_type(team_id, post_reg)
    seazy = games_won_per_season_type(team_id, post_reg).merge(games_per_season_type(team_id, post_reg)) {|season, won, played| won / played.to_f}
    seazy.transform_values{|v| v.round(2)}
  end

  def goals_scored_per_season_type(team_id, post_reg)
    season_goals = Hash.new(0)
    all_seasons_ary.each do |season|
      @games.values.each do |g|
        if g.season == season && g.type == post_reg &&
        g.home_team_id == team_id
        season_goals[season] += g.home_goals
      elsif g.season == season && g.type == post_reg &&
        g.away_team_id == team_id
        season_goals[season] += g.away_goals
        end
      end
    end
    season_goals
  end

  def goals_allowed_per_season_type(team_id, post_reg)
    season_goals = Hash.new(0)
    all_seasons_ary.each do |season|
      @games.values.each do |g|
        if g.season == season && g.type == post_reg && g.home_team_id == team_id
        season_goals[season] += g.away_goals
      elsif g.season == season && g.type == post_reg && g.away_team_id == team_id
        season_goals[season] += g.home_goals
        end
      end
    end
    season_goals
  end

  def average_goals_scored_season_type(team_id, post_reg)
    stat = goals_scored_per_season_type(team_id, post_reg).merge(games_per_season_type(team_id, post_reg)) {|season, goals, games| goals / games.to_f}
    stat.transform_values{|v| v.round(2)}
  end

  def average_goals_allowed_season_type(team_id, post_reg)
    stat = goals_allowed_per_season_type(team_id, post_reg).merge(games_per_season_type(team_id, post_reg)) {|season, goals, games| goals / games.to_f}
    stat.transform_values{|v| v.round(2)}
  end

end
