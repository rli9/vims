require 'pathname'
class SystemMailer < ActionMailer::Base
  def basic_email(subject)
    @subject = subject
    @from = 'todo_from_email'
    @content_type = "text/html"
  end  
  
  def members_update(member)
    basic_email 'FYI: VIMS: Your member information is updated'    
    @body["member"] = member    
    @recipients = member.email
  end
  
  def projects_add_member(member_project_association)
    basic_email "FYI: VIMS: You have been added to project #{member_project_association.project.name}"
    @body["member_project_association"] = member_project_association    
    @recipients = member_project_association.member.email    
  end  
  
  def exception_notification(controller, request, exception)
    basic_email(sprintf("ERROR: VIMS: %s\#%s (%s) %s", controller.controller_name, controller.action_name, exception.class, exception.message.inspect))
    @body = {"controller" => controller, 
             "request" => request, 
             "exeeption" => exception, 
             "host" => request.env["HTTP_HOST"], 
             "rails_root" => Pathname.new(Rails.root).cleanpath.to_s
            }
    @recipients = 'todo_recipient_emails'
  end
end
