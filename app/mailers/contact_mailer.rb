class ContactMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  def contact_mail(contact)
    @contact = contact
    mail to: Settings.contacts[:mail], subject: "お客様からCOOK LABにお問い合わせがありました。"
  end
end
