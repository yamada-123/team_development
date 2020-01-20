class AgendasController < ApplicationController
  # before_aaction :set_agenda, only: %i[show edit update destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end
 
#1
  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda') 
    else
      render :new
    end
  end

  def destroy
    @agenda = Agenda.find(params[:id])
    #binding.irb
    if @current_user.id == @agenda.user_id || @current_user.id == @agenda.team.owner_id
      @agenda.destroy
      @agenda.team.members.each do |user|      
      AgendaMailer.delete_mail(user.email).deliver
      end
      redirect_to dashboard_path, notice: "アジェンダを削除しました"
    else
      redirect_to dashboard_path, notice: "作成者かチームオーナーしか削除できません"
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
