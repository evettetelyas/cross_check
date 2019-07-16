require './lib/stat_tracker'

game_path = './data/game.csv'
team_path = './data/team_info.csv'
game_teams_path = './data/game_teams_stats.csv'
dummy_game_path = './dummy_data/dummy_game.csv'
dummy_team_path = './dummy_data/dummy_team_info.csv'
dummy_game_teams_path = './dummy_data/dummy_game_teams_stats.csv'

locations = {
  games: game_path,
  teams: team_path,
  game_teams: game_teams_path,
  dummy_games: dummy_game_path,
  dummy_teams: dummy_team_path,
  dummy_game_teams: dummy_game_teams_path
}

stat_tracker = StatTracker.from_csv(locations)
binding pry
