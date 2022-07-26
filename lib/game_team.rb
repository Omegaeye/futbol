class GameTeam
  attr_reader :game_id,
              :team_id,
              :hoa,
              :result,
              :settled_in,
              :head_coach,
              :goals,
              :shots,
              :tackles,
              :pin,
              :power_play_opportunities,
              :power_play_goals,
              :face_off_win_percentage,
              :give_aways,
              :take_aways

  def initialize(info)
    @game_id = info[:game_id]
    @team_id = info[:team_id]
    @hoa = info[:hoa]
    @result = info[:result]
    @settled_in = info[:settled_in]
    @head_coach = info[:head_coach]
    @goals = info[:goals]
    @shots = info[:shots]
    @tackles = info[:tackles]
    @pim = info[:pim]
    @power_play_opportunities = info[:powerplayopportunities]
    @power_play_goals = info[:powerplaygoals]
    @face_off_win_percentage = info[:faceoffwinpercentage]
    @give_aways = info[:giveaways]
    @take_aways = info[:takeaways]
  end
end
