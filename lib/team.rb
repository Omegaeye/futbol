class Team
  attr_reader :id,
              :franchise_id,
              :team_name,
              :abbreviation,
              :stadium,
              :link

  def initialize(info)
    @id = info[:id]
    @franchise_id = info[:franchiseId]
    @team_name = info[:teamName]
    @abbreviation = info[:abbreviation]
    @stadium = info[:Statdium]
    @link = info[:link]
  end
end
