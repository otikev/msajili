module ApplicationHelper
  require 'utils'
  
  def activate_link(path)
  'active' if current_page?(path)
  end
  
  def activate_dashboard_link
    'active' if current_page?(dashboard_url) || current_page?(dashboardrecruiter_url) || current_page?(dashboardadmin_url)
  end
  
  def getCurrentPath
    request.url
  end
  
  def nbsp(size)
    max = size.to_i
    i = 0
    space = ''
    begin
      space << "#{0xC2.chr + 0xA0.chr}"
       i +=1
    end while i < max
    space.force_encoding("utf-8")
  end

  def current_user_email
    "#{@current_user.email}"
  end
  
  def current_user_role
    @current_user.role
  end
  
  def generate_datepicker_id
    "datepicker_#{Utils.random_string(5)}"
  end

  def generate_timepicker_id
    "timepicker_#{Utils.random_string(5)}"
  end

  def generate_datetimepicker_id
    "datetimepicker_#{Utils.random_string(5)}"
  end
  
  def generate_tab_id
    "tab-container_#{Utils.random_string(5)}"
  end
  
  def generate_applications_datatable_id
    "datatable-applications_#{Utils.random_string(5)}"
  end

  def generate_user_applications_datatable_id
    "datatable-user-applications_#{Utils.random_string(5)}"
  end

  def generate_jobs_datatable_id
    "datatable-jobs_#{Utils.random_string(5)}"
  end

  def generate_payments_datatable_id
    "datatable-payments_#{Utils.random_string(5)}"
  end

  def generate_users_datatable_id
    "datatable-users_#{Utils.random_string(5)}"
  end
  
  def generate_templates_datatable_id
    "datatable-templates_#{Utils.random_string(5)}"
  end
  
  def generate_procedures_datatable_id
    "datatable-procedures_#{Utils.random_string(5)}"
  end

  def generate_help_popover_id
    "help-popover_#{Utils.random_string(5)}"
  end

  def generic_random_id
    "#{Utils.random_string(8)}"
  end
  
  def country_name_from_code(code)
    country = ISO3166::Country[code]
    country.name
  end
  
  def role_name
    if @current_user.as_admin
      'Admin'
    elsif current_user_role != Role.applicant
      'Recruiter'
    else
      'Applicant'
    end
  end
  
  def higlight_class(expected_section,actual_section,expected_filter,actual_filter)
    if expected_section || actual_section
      if (actual_filter == expected_filter) && (actual_section == expected_section) then 'background_grey' end
    else
      if actual_filter == expected_filter then 'background_grey' end
    end
  end

  def link_to_download(id)
    link_to 'Download', download_path(id: id), class:'btn btn-success btn-xs'
  end

  def link_to_remove_upload(id,return_to)
    link_to 'Remove', removeupload_path(id: id,return_to: return_to), class:'btn btn-danger btn-xs', method: :post
  end

  def link_to_attach_upload(upload_id,application_id)
    link_to 'Attach', attach_path(upload_id: upload_id,application_id: application_id), class:'btn btn-primary btn-xs', method: :post
  end

  def link_to_edit_anonymous_job(id,status,text)
    link_to text, adminjobstatus_path(id: id, status: status), class:'btn btn-success btn-xs'
  end

  def link_to_edit_anonymous_job_custom_fields(id)
    link_to 'Edit', admincustomfields_path(id: id, edit: true), class:'btn btn-primary btn-xs'
  end

  def link_to_edit_job(id)
    link_to 'Edit', showjob_path(id: id), class:'btn btn-success btn-xs'
  end

  def link_to_apply_token(id)
    link_to 'Apply token', applytoken_path(id: id), class:'btn btn-danger btn-xs'
  end

  def link_to_view_company(id)
    link_to 'View', admincompany_path(id: id), class:'btn btn-primary btn-xs'
  end

  def link_to_external_job(token)
   link_to 'Preview', external_url(t:token), class:'btn btn-default btn-xs'
  end 
  
  def link_to_view_template(id)
   link_to 'View', showtemplate_url(id: id), class:'btn btn-default btn-xs'
  end
  
  def link_to_insert_template(template_id,job_token)
   link_to 'Add', inserttemplate_url(template_id:template_id,t:job_token), class:'btn btn-default btn-xs'
  end
  
  def link_to_insert_procedure(procedure_id,job_token)
   link_to 'Add', insertprocedure_url(procedure_id: procedure_id,t:job_token), class:'btn btn-default btn-xs'
  end
  
  def link_to_edit_template(id)
   link_to 'Edit', edittemplate_url(id: id), class:'btn btn-default btn-xs'
  end
  
  def link_to_process_job(token)
    link_to 'Process', processjob_url(t:token), class:'btn btn-primary btn-xs'
  end
  
  def link_to_view_application(application_id)
    link_to 'View', application_url(id: application_id), class:'btn btn-primary btn-xs'
  end

  def link_to_progress_application(application_id)
    link_to 'View', progress_url(id: application_id), class:'btn btn-default btn-xs'
  end

  def link_to_view_procedure(procedure_id)
    link_to 'View', editprocedure_url(id: procedure_id), class:'btn btn-default btn-xs'
  end

  def link_to_edit_staff(id)
    link_to 'Edit', staff_path(id: id), class:'btn btn-primary btn-block btn-xs'
  end

  def status_update_link(status_val,token,active)
    clas=''
    if active
      clas = 'btn btn-default btn-success'
    else
      clas = 'btn btn-default'
    end
    
    if status_val == Job.status_expired
      #Expiration is set automatically once the deadline date passes
      link_to Job.status_name_for_code(status_val), '#', class: clas
    else
      link_to Job.status_name_for_code(status_val), setstatus_path(t:token,status:status_val), class: clas
    end
  end
  
  def format_date(date)
    "<p class='no_wrap'>#{date.to_formatted_s(:long_ordinal)}</p>".html_safe
  end

  def format_date_with_prefix(prefix,date)
    "<p class='no_wrap'>#{prefix} #{date.to_formatted_s(:long_ordinal)}</p>".html_safe
  end

  def form_to_enable_user(user_id)
    capture do
      form_for(:user, url: set_enabled_path, method: 'post') do |f|
        concat f.hidden_field :id, :value => user_id
        concat f.hidden_field :enabled, :value => true
        concat f.submit 'Enable', :class => 'btn btn-success btn-xs'
      end
    end
  end

  def form_to_disable_user(user_id)
    capture do
      form_for(:user, url: set_enabled_path, method: 'post') do |f|
        concat f.hidden_field :id, :value => user_id
        concat f.hidden_field :enabled, :value => false
        concat f.submit 'Disable', :class => 'btn btn-danger btn-xs'
      end
    end
  end
end
