class AgendaMailer < ApplicationMailer
  default from: 'from@example.com'
  def delete_mail(email)
    # @agenda = agenda
    # @email = @agenda.user.email
    # @users = @agenda.team.members
    @email = email
    binding.irb
    mail to: @email, subject: "アジェンダ削除について"
  end
end
