require './spec_helper/spec_helper'

RSpec.describe StatTracker do
  describe '#initialize' do
    let(:locations) do
      {
        games: './data/games.csv',
        teams: './data/teams.csv',
        game_teams: './data/game_teams.csv'
      }
    end

    before do
      @stat_tracker = StatTracker.from_csv(locations)
    end

    it 'should initialize an instant of StatTracker' do
      expect(@stat_tracker).to be_instance_of StatTracker
    end

    it 'has games as attributes' do
      expected_result = %i[
        @id
        @season
        @type
        @date_time
        @away_team_id
        @home_team_id
        @away_goals
        @home_goals
        @venue
        @venue_link
      ]
      expect(@stat_tracker.games).to be_an Array
      expect(@stat_tracker.games.first.instance_variables).to eq(expected_result)
    end

    it 'has teams as attributes' do
      expected_result = %i[
        @id
        @franchise_id
        @team_name
        @abbreviation
        @stadium
        @link
      ]
      # require 'pry'; binding.pry
      expect(@stat_tracker.teams).to be_an Array
      expect(@stat_tracker.teams.first.instance_variables).to eq(expected_result)
    end

    it 'has game_teams as attributes' do
      expected_result = %i[
        @game_id
        @team_id
        @hoa
        @result
        @settled_in
        @head_coach
        @goals
        @shots
        @tackles
        @pim
        @power_play_opportunities
        @power_play_goals
        @face_off_win_percentage
        @give_aways
        @take_aways
      ]
      expect(@stat_tracker.game_teams).to be_an Array
      expect(@stat_tracker.game_teams.first.instance_variables).to eq(expected_result)
    end
  end
end
