class TeamsController < ApplicationController
  before_action :logged_in_user, only:[:index, :new]
  before_action :is_admin, only:[:edit, :update]
  def index_user
    user_now = current_user
    if !user_now.nil?
      @teams = user_now.teams 
    end
  end

  def index
    @teams = Team.all
  end

  def new
    @team = Team.new
  end

  def create
    user_now = current_user
    if !user_now.nil?
      @team = user_now.teams.new(team_params)
      @team.admin_id = user_now.id 
      @team.users << user_now
      if @team.save
        flash[:success] = "Team created successful!"
        redirect_to @team
      else
        flash[:danger] = "Team created failed! Please check the details below."
        render 'new'
      end
    else
      flash[:danger] = "Please log in before you proceed."
      render 'new'
    end
  end

  def show
    @team = Team.find(params[:id])
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update 
    @team = Team.find(params[:id])
    if @team.update_attributes(team_params)
      flash[:success] = "Team updated"
      redirect_to @team
    else
      render 'edit'
    end
  end

  def destroy
    team_now = Team.find(params[:id])
    if current_user?(User.find(team_now.admin_id))
      team_now.destroy
      flash[:success] = "Team deleted"
      redirect_to teams_url
    else
      flash[:danger] = "Internal error! Please contact the admin for help"
      redirect_to teams_url
    end
  end 

  private
    def team_params
      params.require(:team).permit(:name, :description, :invition_code)
    end
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def is_admin
      @team = Team.find(params[:id])
      redirect_to(root_url) unless current_user?(User.find(@team.admin_id))
    end
end
