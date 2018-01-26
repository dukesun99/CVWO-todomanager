class TeamsController < ApplicationController
  before_action :logged_in_user, only:[:index, :new]
  before_action :is_admin, only:[:edit, :update]
  before_action :in_team, only:[:index_member]

  #Index all teams current user joined
  def index_user
    user_now = current_user
    if !user_now.nil?
      @teams = user_now.teams 
    end
  end

  #Index all teams.
  def index
    @teams = Team.all
  end

   #Index all members in a team
  def index_member
    @users = Team.find(params[:team_id]).users
  end

  #Create view for new team.
  def new
    @team = Team.new
  end

  #Create new team.
  def create
    user_now = current_user
    if !user_now.nil? #if logged in user
      @team = user_now.teams.new(team_params)
      @team.admin_id = user_now.id #set team admin to current user
      @team.users << user_now #add current user to team member
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

  #Show view for team
  def show
    @team = Team.find(params[:id])
  end

  #Edit view for team
  def edit
    @team = Team.find(params[:id])
  end

  #Update team info
  def update 
    @team = Team.find(params[:id])
    if @team.update_attributes(team_params)
      flash[:success] = "Team updated"
      redirect_to @team
    else
      render 'edit'
    end
  end

  #Destroy team
  def destroy
    team_now = Team.find(params[:id])
    #if current_user?(User.find(team_now.admin_id))
    if current_user?(User.find(team_now.admin_id))
      team_now.destroy
      flash[:success] = "Team deleted"
      redirect_to teams_url
    else
      flash[:danger] = "Internal error! Please contact the admin for help"
      redirect_to teams_url
    end
  end 

  #Create view for user to join a team
  def apply_team
    @team = Team.find(params[:team_id])
  end

  #Controller to check whether a user has entered correct invition code and if so then add that user otherwise not
  def add_user
    team_now = Team.find(params[:team_id])
    #if user entered correct invition code and not in the team
    if team_now.invition_code == params[:invition_code] && !team_now.users.include?(current_user)
      team_now.users << current_user #Add current user to the team
      flash[:success] = "You successfully joined the team!"
      redirect_to team_now
    else
      flash[:danger] = "Failed to join the team. Maybe you entered invalid invition code or you are already in the team."
      redirect_to teams_path
    end
  end

  private
    def team_params
      params.require(:team).permit(:name, :description, :invition_code)
    end

    #Confirms a logged in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    #Confirms current user is the admin of the team.
    def is_admin
      @team = Team.find(params[:id])
      if !current_user?(User.find(@team.admin_id))
        flash[:danger] = "You have no right to access this page!"
        redirect_to(root_url)
      end
    end

    #Confirms current user is a member of the team.
    def in_team 
      @team = Team.find(params[:team_id])
      if !@team.users.include?(current_user)
        flash[:danger] = "You have no right to access this page!"
        redirect_to(root_url)
      end
    end
end
