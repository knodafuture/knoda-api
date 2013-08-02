class ReportsMailer < ActionMailer::Base
  default from: "reports@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reports_mailer.daily.subject
  #
  def daily(users, predictions)
    @users = users
    @predictions = predictions

    mail to: "test@example.com"
  end
end
