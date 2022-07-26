require 'CSV'
require './lib/game'
require './lib/team'
require './lib/game_team'

class StatTracker
  attr_reader :games, :teams, :game_teams

  def initialize(locations)
    @games = all(locations[:games], 'Game')
    @teams = all(locations[:teams], 'Team')
    @game_teams = all(locations[:game_teams], 'GameTeam')
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def all(path, class_name)
    all = []

    CSV.foreach(path, headers: true, header_converters: :symbol) do |data|
      all << Kernel.const_get(class_name).new(data)
    end

    all
  end
end
