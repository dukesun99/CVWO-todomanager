class TasksController < ApplicationController
    before_action :correct_user, only: [:index_user]
    before_action :logged_in_user, only: [:index_team, :new, :edit, :update, :destroy]

    def index_user
        user_now = User.find(params[:user_id])
        @tasks = user_now.tasks
    end

    def index_team
        team_now = Team.find(params[:team_id])
        @tasks = team_now.tasks.paginate(page: params[:page]) if member_checker(team_now)
    end

    def show
        @task = Task.find(params[:id])
    end

    def create
        if !current_user.nil? && params[:father_id] == '0'
            user_now = current_user
            @task = user_now.tasks.new(params.require(:task).permit(:title, :detail, :due_date, :importance, :category))
            if @task.save
                flash[:success] = "Task created successfully!"
                #redirect_to "/users/#{user_now.id}/tasks"
                render 'new'
            else
                render 'new'
            end
        else
            if params[:father_id] == nil
                flash[:danger] = "You must select one team or user to create this task with"
            else
                team_now = Team.find(params[:father_id])
                @task = team_now.tasks.new(params.require(:task).permit(:title, :detail, :due_date, :importance, :category))
                if @task.save
                    flash[:success] = "Task created successfully!"
                    render 'new'
                else
                    render 'new'
                end
            end
        end
    end
        

    def new
        @task = Task.new
    end

    def edit
        @task = Task.find(params[:id])
    end

    def update
        @task = Task.find(params[:id])
        if permittion_checker(@task) && @task.update_attributes(task_params_for_edit)
        flash[:success] = "Task updated"
        redirect_to @task
        else
        render 'edit'
        end
    end

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
        def task_params
            params.require(:task).permit(:title, :detail, :due_date, :importance,  :father_id, :category, :cat_name)
        end

        def task_params_for_edit
            params.require(:task).permit(:title, :detail, :due_date, :importance, :category)
        end

        def logged_in_user
            unless logged_in?
              store_location
              flash[:danger] = "Please log in."
              redirect_to login_url
            end
        end

        def correct_user
            @user_now = User.find(params[:user_id])
            redirect_to(root_url) unless current_user?(@user_now)
        end

        def permittion_checker (tsk)
            if tsk.taskable_type == "User"
                return tsk.taskable == current_user
            else
                if tsk.taskable_type == "Team"
                    if current_user.teams.users.include?(current_user)
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
