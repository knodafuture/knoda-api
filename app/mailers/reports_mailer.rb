class ReportsMailer < ActionMailer::Base
  default from: Knoda::Application.config.reports_mailer_from

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reports_mailer.daily.subject
  #
  def daily(users, predictions)
    @users = users
    @predictions = predictions

    mail to: Knoda::Application.config.reports_mailer_to
  end
end
