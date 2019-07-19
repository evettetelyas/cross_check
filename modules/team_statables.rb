module TeamStatables
  include LeagueStatables

  def team_info(team_id)
    @teams[team_id].hashify
  end

  def best_season(team_id)
    best_season_stat = all_season_hash(team_id).max_by {|k,v| v}
    best_season_stat[0]
  end

  def worst_season(team_id)
    worst_season_stat = all_season_hash(team_id).min_by {|k,v| v}
    worst_season_stat[0]
  end

  def all_season_hash(team_id)
    all_games_won_by_season(team_id).merge(all_games_played_by_season(team_id)) {|season, won, played| won / played.to_f}
  end

  def all_games_played_by_season(team_id)
    all_season_games = Hash.new
    all_seasons_ary = []
    @games.values.map do |game|
      all_seasons_ary << game.season
    end
    all_seasons_ary.uniq.each do |season|
      all_season_games[season] = @games.values.count {|g| g.season == season && (g.home_team_id == team_id || g.away_team_id == team_id)}
    end
    all_season_games
  end

  def all_games_won_by_season(team_id)
    all_season_won_games = Hash.new
    all_seasons_ary = []
    @games.values.map do |game|
      all_seasons_ary << game.season
    end
    all_seasons_ary.uniq.each do |season|
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

  def average_win_percentage(team_id)
    all_wins = all_games_won_by_season(team_id).values.sum
    all_games = all_games_played_by_season(team_id).values.sum
    avg = all_wins/all_games.to_f
    avg.round(2)
  end

  def all_game_goals(team_id)
    all_goals_by_game = Hash.new
    all_games = []
    @games.values.each do |game|
      if team_id == game.home_team_id || game.away_team_id
        all_games << game
      end
    end
    all_games.each do |game|
      if team_id == game.home_team_id
      all_goals_by_game[game] = game.home_goals
      elsif team_id == game.away_team_id
      all_goals_by_game[game] = game.away_goals
      end
    end
    all_goals_by_game
  end

  def most_goals_scored(team_id)
    most_goals_stat = all_game_goals(team_id).max_by {|k,v| v}
    most_goals_stat[1]
  end

  def fewest_goals_scored(team_id)
    fewest_goals_stat = all_game_goals(team_id).min_by {|k,v| v}
    fewest_goals_stat[1]
  end

  def opponent_games_played(team_id)
    opponent_stats = Hash.new(0)
    @teams.values.each do |team|
      opponent_stats[team.team_id] = 0
    end
    opponent_stats.each do |other_team_id, num_wins|
      @game_teams.values.each do |g|
        if @games[g.game_id].home_team_id == other_team_id && @games[g.game_id].away_team_id == team_id
          opponent_stats[@games[g.game_id].home_team_id] += 1
        elsif @games[g.game_id].away_team_id == other_team_id && @games[g.game_id].home_team_id == team_id
          opponent_stats[@games[g.game_id].away_team_id] += 1
        end
      end
    end
    opponent_stats.each do |team_id, games|
      if games == 0
        opponent_stats.delete(team_id)
      end
    end
  end

  def opponent_games_lost(team_id)
    opponent_stats = Hash.new(0)
    @teams.values.each do |team|
      opponent_stats[team.team_id] = 0
    end
    opponent_stats.each do |other_team_id, num_wins|
      @game_teams.values.each do |g|
        if @games[g.game_id].home_team_id == other_team_id && @games[g.game_id].away_team_id == team_id && @games[g.game_id].away_goals < @games[g.game_id].home_goals
          opponent_stats[@games[g.game_id].home_team_id] += 1
        elsif @games[g.game_id].away_team_id == other_team_id && @games[g.game_id].home_team_id == team_id && @games[g.game_id].away_goals > @games[g.game_id].home_goals
          opponent_stats[@games[g.game_id].away_team_id] += 1
        end
      end
    end
    opponent_stats
  end

  def opponent_games_won(team_id)
    opponent_stats = Hash.new(0)
    @teams.values.each do |team|
      opponent_stats[team.team_id] = 0
    end
    opponent_stats.each do |other_team_id, num_wins|
      @game_teams.values.each do |g|
        if @games[g.game_id].home_team_id == other_team_id && @games[g.game_id].away_team_id == team_id && @games[g.game_id].away_goals > @games[g.game_id].home_goals
          opponent_stats[@games[g.game_id].home_team_id] += 1
        elsif @games[g.game_id].away_team_id == other_team_id && @games[g.game_id].home_team_id == team_id && @games[g.game_id].away_goals < @games[g.game_id].home_goals
          opponent_stats[@games[g.game_id].away_team_id] += 1
        end
      end
    end
    opponent_stats
  end

  def favorite_opponent_stats(team_id)
   opponent_games_won(team_id).merge(opponent_games_played(team_id)) {|opponent, lost, played| lost / played.to_f}
  end

  def rival_opponent_stats(team_id)
   opponent_games_lost(team_id).merge(opponent_games_played(team_id)) {|opponent, lost, played| lost / played.to_f}
  end

  def favorite_opponent(team_id)
    worst_team = favorite_opponent_stats(team_id).max_by {|k,v| v}
    @teams[worst_team[0]].team_name
  end

  def rival(team_id)
    best_team = rival_opponent_stats(team_id).max_by {|k,v| v}
    @teams[best_team[0]].team_name
  end

  def biggest_team_blowout_hash(team_id)
    opponent_blowout_stats = Hash.new(0)
    @teams.values.each do |team|
      opponent_blowout_stats[team.team_id] = []
    end
    opponent_blowout_stats.each do |other_team_id, blowout_abs|
      @game_teams.values.each do |g|
        if @games[g.game_id].home_team_id == other_team_id &&
          @games[g.game_id].away_team_id == team_id &&
          @games[g.game_id].away_goals > @games[g.game_id].home_goals
          opponent_blowout_stats[@games[g.game_id].home_team_id] << ((@games[g.game_id].home_goals - @games[g.game_id].away_goals).abs)
        elsif @games[g.game_id].away_team_id == other_team_id &&
          @games[g.game_id].home_team_id == team_id &&
          @games[g.game_id].away_goals < @games[g.game_id].home_goals
          opponent_blowout_stats[@games[g.game_id].away_team_id] << ((@games[g.game_id].home_goals - @games[g.game_id].away_goals).abs)
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
      @game_teams.values.each do |g|
        if @games[g.game_id].home_team_id == other_team_id &&
          @games[g.game_id].away_team_id == team_id &&
          @games[g.game_id].away_goals < @games[g.game_id].home_goals
          opponent_blowout_stats[@games[g.game_id].home_team_id] << ((@games[g.game_id].home_goals - @games[g.game_id].away_goals).abs)
        elsif @games[g.game_id].away_team_id == other_team_id &&
          @games[g.game_id].home_team_id == team_id &&
          @games[g.game_id].away_goals > @games[g.game_id].home_goals
          opponent_blowout_stats[@games[g.game_id].away_team_id] << ((@games[g.game_id].home_goals - @games[g.game_id].away_goals).abs)
        end
      end
    end
    opponent_blowout_stats
  end


  def biggest_team_blowout(team_id)
    biggest_team_blowout_hash(team_id).values.flatten.uniq.max
  end

  def worst_loss(team_id)
    biggest_team_loss_hash(team_id).values.flatten.uniq.max
  end

  def head_to_head_hash(team_id)
    opponent_stats = Hash.new(0)
    @teams.values.each do |team|
      opponent_stats[team.team_name] = [0,0] #[0]=wins, [1]=total games
    end
    opponent_stats.each do |other_team_name, num_wins|
      @game_teams.values.each do |g|
        if @teams[@games[g.game_id].home_team_id].team_name == other_team_name &&
          @games[g.game_id].away_team_id == team_id &&
          @games[g.game_id].away_goals > @games[g.game_id].home_goals
          opponent_stats[@teams[@games[g.game_id].home_team_id].team_name][0] += 1
        elsif @teams[@games[g.game_id].away_team_id].team_name == other_team_name &&
          @games[g.game_id].home_team_id == team_id &&
          @games[g.game_id].away_goals < @games[g.game_id].home_goals
          opponent_stats[@teams[@games[g.game_id].away_team_id].team_name][0] += 1
        end
        if @teams[@games[g.game_id].home_team_id].team_name == other_team_name &&
          @games[g.game_id].away_team_id == team_id
          opponent_stats[@teams[@games[g.game_id].home_team_id].team_name][1] += 1
        elsif @teams[@games[g.game_id].away_team_id].team_name == other_team_name &&
          @games[g.game_id].home_team_id == team_id
          opponent_stats[@teams[@games[g.game_id].away_team_id].team_name][1] += 1
        end
      end
    end
    opponent_stats.each do |team_name, games|
      if games[1] == 0
        opponent_stats.delete(team_name)
      end
    end
  end

  def head_to_head(team_id)
   head_to_head_hash(team_id).transform_values {|v| (v[0]/v[1].to_f).round(2)}
  end

  def seasonal_summary(team_id)
    post_season_games = Hash.new(0)
    all_seasons_ary = []
    @games.values.map do |game|
      all_seasons_ary << game.season
    end
    all_seasons_ary.uniq.each do |season|
      post_season_games[season] = {postseason: Hash.new, regular_season: Hash.new}
    end
    post_season_games.each do |season, stats|
      post_season_games[season][:postseason][:win_percentage] = season_win_percentages_type(team_id, "P")[season]
      post_season_games[season][:postseason][:total_goals_scored] = goals_scored_per_season_type(team_id, "P")[season]
      post_season_games[season][:postseason][:total_goals_against] = goals_allowed_per_season_type(team_id, "P")[season]
      post_season_games[season][:postseason][:average_goals_scored] = average_goals_scored_season_type(team_id, "P")[season]
      post_season_games[season][:postseason][:average_goals_against] = average_goals_allowed_season_type(team_id, "P")[season]
      post_season_games[season][:regular_season][:win_percentage] = season_win_percentages_type(team_id, "R")[season]
      post_season_games[season][:regular_season][:total_goals_scored] = goals_scored_per_season_type(team_id, "R")[season]
      post_season_games[season][:regular_season][:total_goals_against] = goals_allowed_per_season_type(team_id, "R")[season]
      post_season_games[season][:regular_season][:average_goals_scored] = average_goals_scored_season_type(team_id, "R")[season]
      post_season_games[season][:regular_season][:average_goals_against] = average_goals_allowed_season_type(team_id, "R")[season]
    end
  end

  def games_per_season_type(team_id, post_reg)
    post_season_games = Hash.new(0)
    all_seasons_ary = []
    @games.values.map do |game|
      all_seasons_ary << game.season
    end
    all_seasons_ary.uniq.each do |season|
      post_season_games[season] = @games.values.count {|g| g.season == season && g.type == post_reg && (g.home_team_id == team_id || g.away_team_id == team_id)}
    end
    post_season_games
  end

  def games_won_per_season_type (team_id, post_reg)
    post_season_games = Hash.new(0)
    all_seasons_ary = []
    @games.values.map do |game|
      all_seasons_ary << game.season
    end
    all_seasons_ary.uniq.each do |season|
      post_season_games[season] << @games.values.count do |g|
        g.season == season && g.type == post_reg &&
        (g.home_team_id == team_id || g.away_team_id == team_id) &&
        if g.home_team_id == team_id &&
          g.home_goals > g.away_goals
          post_season_games[season] += 1
        elsif g.away_team_id == team_id &&
          g.away_goals > g.home_goals
          post_season_games[season] += 1
        end
      end
    end
    post_season_games
  end

  def season_win_percentages_type(team_id, post_reg)
    post_seazy = games_won_per_season_type(team_id, post_reg).merge(games_per_season_type(team_id, post_reg)) {|season, won, played| won / played.to_f}
    post_seazy.transform_values{|v| v.round(2)}
  end

  def goals_scored_per_season_type(team_id, post_reg)
    post_season_goals = Hash.new(0)
    all_seasons_ary = []
    @games.values.map do |game|
      all_seasons_ary << game.season
    end
    all_seasons_ary.uniq.each do |season|
      @games.values.each do |g|
        if g.season == season && g.type == post_reg &&
        g.home_team_id == team_id
        post_season_goals[season] += g.home_goals
      elsif g.season == season && g.type == post_reg &&
        g.away_team_id == team_id
        post_season_goals[season] += g.away_goals
        end
      end
    end
    post_season_goals
  end

  def goals_allowed_per_season_type(team_id, post_reg)
    post_season_goals = Hash.new(0)
    all_seasons_ary = []
    @games.values.map do |game|
      all_seasons_ary << game.season
    end
    all_seasons_ary.uniq.each do |season|
      @games.values.each do |g|
        if g.season == season && g.type == post_reg &&
        g.home_team_id == team_id
        post_season_goals[season] += g.away_goals
      elsif g.season == season && g.type == post_reg &&
        g.away_team_id == team_id
        post_season_goals[season] += g.home_goals
        end
      end
    end
    post_season_goals
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
