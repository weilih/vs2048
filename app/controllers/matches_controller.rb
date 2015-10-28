class MatchesController < ApplicationController
  before_action :set_match, except: [:index, :new]
  before_action :authenticate_players, except: [:index, :new]

  def index
    @users = User.exclude(current_user)
  end

  def show
  end

  def new
    if @match = Match.create(players: [params[:user], current_user.id])
      redirect_to @match
    else
      redirect_to root_path
    end
  end

  def update
    if @match.whos_turn == current_user.id && @match.action(params[:move])
      respond_to :js
    else
      render nothing: true
    end
  end

  def refresh
    if @match.whos_turn == current_user.id
      respond_to :js
    else
      render nothing: true
    end
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
end
