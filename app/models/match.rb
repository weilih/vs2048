class Match < ActiveRecord::Base
  before_create :prepare_game

  def whos_turn
    players[moves % players.size]
  end

  def action(action)
    update(state: state << action)
    increment!(:moves)
  end

  private

  def prepare_game
    self.state = []
  end
end
