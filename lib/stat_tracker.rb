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
    (@games.find_all { |game| game.home_goals > game.away_goals }.count.to_f / @games.count).round(2)
  end

  def percentage_visitor_wins
    (@games.find_all { |game| game.away_goals > game.home_goals }.count.to_f / @games.count).round(2)
  end

  def percentage_ties
    (@games.find_all { |game| game.away_goals == game.home_goals }.count.to_f / @games.count).round(2)
  end

  def count_of_games_by_season
    season = game_group_by_season

    season.each do |k, v|
      season[k] = v.count
    end
  end

  def average_goals_per_game
    (total_game_score.sum / @games.count.to_f).round(2)
  end

  def total_game_score
    @total_game_score ||= @games.map { |game| game.home_goals + game.away_goals }
  end

  def game_group_by_season
    @games.group_by(&:season)
  end

  def average_goals_by_season
    season = game_group_by_season

    season.each do |k, v|
      season[k] = (v.sum { |game| game.home_goals + game.away_goals } / v.count.to_f).round(2)
    end
  end

  #League Statistic
end
