class ContactMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  def contact_mail(contact)
    @contact = contact
    # mail to: ENV['MAIL'], subject: "お客様からCOOK LABにお問い合わせがありました。"
    mail to: 'sp2h5vb9ni@yahoo.co.jp', subject: "お客様からCOOK LABにお問い合わせがありました。"
  end
end
