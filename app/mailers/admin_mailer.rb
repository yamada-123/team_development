class AdminMailer < ApplicationMailer
  default from: 'from@example.com'
  def change_mail(email)
    # @agenda = agenda
    # @email = @agenda.user.email
    # @users = @agenda.team.members
    @email = email
    binding.irb
    mail to: @email, subject: "チーム内権限変更について"
  end
end
