class MatchesController < ApplicationController
  before_action :set_match, except: [:index, :new]
  before_action :authenticate_players, except: [:index, :new, :join]

  def index
    redirect_to root_path and return unless current_user
    @users = User.exclude(current_user)
    @new_matches = Match.new_game
  end

  def show
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
      if @match.winner.zero?
        @info = { action: 'refresh', msg: "Draw"}
      else
        @info = { action: 'refresh', msg: "#{User.find(@match.winner)} Wins!"}
      end
    else
      if @match.whos_turn == current_user
        @info = { action: 'pause', msg: "Your turn"}
      else
        @info = { action: 'refresh', msg: "Wait..."}
      end
    end
  end
end
