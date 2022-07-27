require 'CSV'
require_relative 'game'
require_relative 'team'
require_relative 'game_team'

class StatTracker
  attr_reader :games, :teams, :game_teams

  def initialize(locations)
    @games = create_records_array(locations[:games], 'Game')
    @teams = create_records_array(locations[:teams], 'Team')
    @game_teams = create_records_array(locations[:game_teams], 'GameTeam')
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def create_records_array(path, class_name)
    record_array = []

    CSV.foreach(path, headers: true, header_converters: :symbol) do |data|
      record_array << Kernel.const_get(class_name).new(data)
    end

    record_array
  end

  # Game Statistic

  def highest_total_score
    total_game_score.max
  end

  def lowest_total_score
    total_game_score.min
  end

  def percentage_home_wins
    (@games.find_all { |game| game.home_goals.to_i > game.away_goals.to_i }.count.to_f / @games.count).round(2)
  end

  def percentage_visitor_wins
    (@games.find_all { |game| game.away_goals.to_i > game.home_goals.to_i }.count.to_f / @games.count).round(2)
  end

  def percentage_ties
    (@games.find_all { |game| game.away_goals.to_i == game.home_goals.to_i }.count.to_f / @games.count).round(2)
  end

  def count_of_games_by_season
    season ||= game_group_by_season

    season.each do |k, v|
      season[k] = v.count
    end
  end

  def average_goals_per_game
    (total_game_score.sum / @games.count.to_f).round(2)
  end

  def average_goals_by_season
    season ||= game_group_by_season

    season.each do |k, v|
      season[k] = (v.sum { |game| game.home_goals.to_i + game.away_goals.to_i } / v.count.to_f).round(2)
    end
  end

  # League Statistic

  def count_of_teams
    @teams.count
  end

  def best_offense
    team_id = team_ids_by_goals_hash.max_by { |_k, v| v }.first

    find_team_name(team_id)
  end

  def worst_offense
    team_id = team_ids_by_goals_hash.min_by { |_k, v| v }.first

    find_team_name(team_id)
  end

  def highest_scoring_visitor
    team_id = team_away_home_goals.max_by { |_k, v| v[:away] }.first

    find_team_name(team_id)
  end

  def lowest_scoring_visitor
    team_id = team_away_home_goals.min_by { |_k, v| v[:away] }.first

    find_team_name(team_id)
  end

  def lowest_scoring_home_team
    team_id = team_away_home_goals.min_by { |_k, v| v[:home] }.first

    find_team_name(team_id)
  end

  def highest_scoring_home_team
    team_id = team_away_home_goals.max_by { |_k, v| v[:home] }.first

    find_team_name(team_id)
  end

  # Team Statistic

  def team_info(team_id)
    team_to_get_info = @teams.find { |team| team.id == team_id }

    {
      'team_id' => team_to_get_info.id,
      'franchise_id' => team_to_get_info.franchise_id,
      'team_name' => team_to_get_info.team_name,
      'abbreviation' => team_to_get_info.abbreviation,
      'link' => team_to_get_info.link
    }
  end

  # def best_season(team_id)
  #   require 'pry'; binding.pry
  # end

  private

  def game_teams_group_by_team_id
    @game_teams.group_by(&:team_id)
  end

  def team_ids_by_goals_hash
    teams_hash = game_teams_group_by_team_id

    teams_hash.each do |team_id, game_teams|
      teams_hash[team_id] = (game_teams.map(&:goals).map(&:to_i).sum.to_f / game_teams.count).round(2)
    end
  end

  def find_team_name(team_id)
    @teams.find { |team| team.id == team_id }.team_name
  end

  def total_game_score
    @total_game_score ||= @games.map { |game| game.home_goals.to_i + game.away_goals.to_i }
  end

  def game_group_by_season
    @game_group_by_season = @games.group_by(&:season)
  end

  def team_away_home_goals
    game_teams_hash ||= game_teams_group_by_team_id
    game_teams_hash.each do |team_id, game_teams|
      game_teams_hash[team_id] = Hash.new { 0 }

      game_teams.each do |game_team|
        if game_team.hoa == 'away' && team_id == game_team.team_id
          game_teams_hash[team_id][:away] += game_team.goals.to_i
        end
        if game_team.hoa == 'home' && team_id == game_team.team_id
          game_teams_hash[team_id][:home] += game_team.goals.to_i
        end
      end
      game_teams_hash[team_id][:away] = (game_teams_hash[team_id][:away].to_f / game_teams.count).round(2)
      game_teams_hash[team_id][:home] = (game_teams_hash[team_id][:home].to_f / game_teams.count).round(2)
    end

    game_teams_hash
  end
end
