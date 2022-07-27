class Team
  attr_reader :id,
              :franchise_id,
              :team_name,
              :abbreviation,
              :stadium,
              :link

  def initialize(info)
    @id = info[:team_id].to_i
    @franchise_id = info[:franchiseid].to_i
    @team_name = info[:teamname]
    @abbreviation = info[:abbreviation]
    @stadium = info[:stadium]
    @link = info[:link]
  end
end
