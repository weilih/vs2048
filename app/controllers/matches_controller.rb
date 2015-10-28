class MatchesController < ApplicationController
  def index
    @users = User.exclude(current_user)
  end

  def show
    @match = Match.find(params[:id])
  end

  def new
    if @match = Match.create(players: [params[:user], current_user.id])
      redirect_to @match
    else
      redirect_to root_path
    end
  end

  def update
    @match = Match.find(params[:id])
    if @match.whos_turn == current_user.id && @match.action(params[:move])
      respond_to :js
    else
      render nothing: true
    end
  end

  def refresh
    @match = Match.find(params[:id])
    @disable = @match.whos_turn == current_user.id
    respond_to :js
  end
end
