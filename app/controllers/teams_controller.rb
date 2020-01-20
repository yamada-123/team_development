class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[show edit update destroy admin_change]

  def index
    @teams = Team.all
  end

  def admin_change
    if  @team.owner_id != params[:assign_user_id].to_i
      #binding.irb
      @user = User.find(params[:assign_user_id])
      @team.owner_id = @user.id
      @team.save
      #binding.pry
      @team.members.each do |user|
      # User.where(id: params[:assign_user_id]) = @team.owner_id
      AdminMailer.change_mail(user.email).deliver
    end
    redirect_to dashboard_url, notice: "チーム内権限を変更しました" 
    else
     # binding.pry
      redirect_to dashboard_path, notice: "すでに権限を持っています"
    end
  end

  def show
    @working_team = @team
    change_keep_team(current_user, @team)
  end

  def new
    @team = Team.new
  end

  def edit
    #binding.irb
    if 
      @team.owner_id == current_user.id
    else
      redirect_to dashboard_path, notice: "チームの管理者権限がありません。"
    end 
  end
    # ; end

  def create
    @team = Team.new(team_params)
    @team.owner = current_user
    if @team.save
      @team.invite_member(@team.owner)
      redirect_to @team, notice: I18n.t('views.messages.create_team')
    else
      flash.now[:error] = I18n.t('views.messages.failed_to_save_team')
      render :new
    end
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: I18n.t('views.messages.update_team')
    else
      flash.now[:error] = I18n.t('views.messages.failed_to_save_team')
      render :edit
    end
  end

  def destroy
    #binding.irb
    @team.destroy
    redirect_to teams_url, notice: I18n.t('views.messages.delete_team')
  end

  def dashboard
    @team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : current_user.teams.first
  end

  private

  def set_team
    @team = Team.friendly.find(params[:id])
  end

  def team_params
    params.fetch(:team, {}).permit %i[name icon icon_cache owner_id keep_team_id]
  end
end
