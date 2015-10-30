class Match < ActiveRecord::Base
  enum status: ['new_game', 'game_ready', 'play_game', 'game_end']
  before_create :prepare_game

  def whos_turn
    User.find_by(id: players[moves % players.size])
  end

  def include?(user)
    players.include?(user.id)
  end

  def action(direction)
    @game_engine = GameEngine.new(state)
    stack_to(direction) unless winner

    if @game_engine.has_2048?
      update(winner: whos_turn.id, status: 3)
    elsif @game_engine.is_over?
      self.state = @game_engine.board
      update(winner: 0, state: @game_engine.board, status: 3)
    else
      increment!(:moves) if @game_engine.valid
    end
  end

  def players_name
    User.where(id: players).pluck(:username)
  end

  def in_ascii
    state.map do |row|
      row.map { |chr| "____#{chr}"[-4..-1] }.join('|')
    end
  end

  private

  def prepare_game
    @game_engine = GameEngine.new
    self.state = @game_engine.board
  end

  def stack_to(direction)
    case direction
    when '37'
      self.state = @game_engine.stack_to_left
    when '38'
      self.state = @game_engine.stack_to_top
    when '39'
      self.state = @game_engine.stack_to_right
    when '40'
      self.state = @game_engine.stack_to_bottom
    end
    update(state: state, status: 2)
  end
end
