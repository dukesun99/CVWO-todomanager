class TasksController < ApplicationController
    before_action :correct_user, only: [:index_user]
    before_action :logged_in_user, only: [:index_team, :new, :edit, :update, :destroy]

    #Show all tasks belongs to a user and all tasks belong to teams the user joined
    def index_user
        user_now = User.find(params[:user_id])
        tasks = user_now.tasks.dup
        if !user_now.teams.nil?
            user_now.teams.each do |team|
                if !team.tasks.nil?
                    tasks = tasks + team.tasks
                end
            end
        end
        @tasks = tasks
    end

    #Show all tasks belongs to a team
    def index_team
        @team_now = Team.find(params[:team_id])
        if @team_now.users.include?(current_user)
            @tasks = @team_now.tasks
        else
            flash[:danger] = "You have no access to the task list of the team"
            redirect_to teams_path
        end
    end

    #Show view of a task
    def show
        @task = Task.find(params[:id])
        if !permittion_checker(@task)
            flash[:danger] = "You have no access to this task!"
            redirect_to my_tasks_path(current_user)
        end
    end

    #Create a new task.
    #Params: :father_id is the pass in parameter which user selected in view that whether they want to create
    #the task for themselves or for their teams. '0' stands for themselves, while other numbers stands for
    #id of the team they want to create this task for.
    def create
        if !current_user.nil? && params[:father_id] == '0'#logged in user and want to create task for themselves
            user_now = current_user
            @task = user_now.tasks.new(params.require(:task).permit(:title, :detail, :due_date, :importance, :category))
            if @task.save
                flash[:success] = "Task created successfully!"
                #redirect_to "/users/#{user_now.id}/tasks"
                redirect_to my_tasks_path(user_now)
            else
                render 'new'
            end
        else
            if params[:father_id].nil?
                flash[:danger] = "You must select one team or user to create this task with"
                @task = Task.new
                render 'new'
            else
                team_now = Team.find(params[:father_id])
                @task = Task.new(params.require(:task).permit(:title, :detail, :due_date, :importance, :category))
                #@task.taskable_type = 'Team'
                @task.taskable = team_now #Add team to the task ? Maybe not necessary
                if @task.save
                    flash[:success] = "Task created successfully with team #{@task.taskable.name}"
                    redirect_to team_tasks_path(team_now)
                else
                    render 'new'
                end
            end
        end
    end
        
    #New view for task 
    def new
        @task = Task.new
    end

    #Edit view for task
    def edit
        @task = Task.find(params[:id])
    end

    #Update tasks
    def update
        @task = Task.find(params[:id])
        if permittion_checker(@task) && @task.update_attributes(task_params_for_edit)
        flash[:success] = "Task updated"
        redirect_to @task
        else
        render 'edit'
        end
    end

    #Destroy task
    def destroy
        tsk = Task.find(params[:id])
        if permittion_checker(tsk)
            tsk.destroy 
            flash[:success] = "Task deleted"
            redirect_to my_tasks_path(current_user)
        else
            flash[:danger] = "Internal error! Please contact admin for help!"
            redirect_to my_tasks_path(current_user)
        end
      end

    private

        def task_params_for_edit
            params.require(:task).permit(:title, :detail, :due_date, :importance, :category)
        end

        #Whether a user is logged in or not
        def logged_in_user
            unless logged_in?
              store_location
              flash[:danger] = "Please log in."
              redirect_to login_url
            end
        end

        #Whether current user is accessing the correct task list
        def correct_user
            @user_now = User.find(params[:user_id])
            redirect_to(root_url) unless current_user?(@user_now)
        end

        #Check whether current user has access to this task(personal task or a task in his teams)
        def permittion_checker (tsk)
            if tsk.taskable_type == "User"
                return tsk.taskable == current_user
            else
                if tsk.taskable_type == "Team"
                    if tsk.taskable.users.include?(current_user)
                        return true
                    else
                        return false
                    end
                else
                    return false
                end
            end
        end


end
