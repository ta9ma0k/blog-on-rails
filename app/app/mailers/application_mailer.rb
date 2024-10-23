class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
  prepend_view_path "app/views/mailers"
end
