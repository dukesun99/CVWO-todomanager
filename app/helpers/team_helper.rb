module TeamHelper
    def member_checker(team_to_check)
        team_to_check.users.include?(current_user)
    end
end
