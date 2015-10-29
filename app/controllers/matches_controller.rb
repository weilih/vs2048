class MatchesController < ApplicationController
  before_action :set_match, except: [:index, :new]
  before_action :authenticate_players, except: [:index, :new, :join]

  def index
    redirect_to root_path and return unless current_user
    current_user.online!
    @users = User.exclude(current_user)
    @new_matches = Match.new_game
  end

  def show
    current_user.playing!
    match_info_updates!
  end

  def new
    if opponent = params[:user]
      @match = Match.create(players: [params[:user], current_user.id],
                            status: Match.statuses[:game_ready])
      redirect_to @match
    else
      @match = Match.create(players: [current_user.id])
      redirect_to matches_path
    end
  end

  def update
    if @match.whos_turn == current_user && @match.action(params[:move])
      match_info_updates!
      respond_to :js
    else
      render nothing: true
    end
  end

  def join
    @match.update(players: @match.players << current_user.id) if current_user
    redirect_to matches_path
  end

  def start
    @match.update(status: 1)
    redirect_to @match
  end

  def refresh
    ## commented out to support 3+ player mode
    ## otherwise it only refresh when current_user's turn
    # if @match.whos_turn == current_user || @match.winner
      match_info_updates!
      respond_to :js
    # else
      # render nothing: true
    # end
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def authenticate_players
    redirect_to root_path and return unless current_user

    if @match.players.include?(current_user.id)
      return true
    else
      redirect_to matches_path and return
    end
  end

  def match_info_updates!
    if @match.winner
      @info = game_over(@match.winner)
    elsif !still_playing?(@match.players) && !@match.moves.zero?
      @match.update(winner: 0)
      @info = { action: 'leave', msg: 'Your opponent ran away...'}
    else
      @info = wait_next_move(@match.whos_turn)
    end
  end

  def game_over(winner)
    if winner.zero?
      { action: 'refresh', msg: "Draw"}
    else
      { action: 'refresh', msg: "#{User.find(winner)} Wins!"}
    end
  end

  def wait_next_move(player)
    if player == current_user
      { action: 'pause', msg: "Your turn"}
    else
      { action: 'refresh', msg: "Wait..."}
    end
  end

  def still_playing?(players = [])
    User.where(id: players).pluck(:status).uniq == [User.statuses['playing']]
  rescue
    false
  end
end
