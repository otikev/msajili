class UploadsController < ApplicationController
  before_action :login_required

  def attach
    upload = Upload.where(:id => params[:upload_id].to_i).first
    application = Application.where(:id => params[:application_id].to_i).first
    if upload and application and upload.user_id == @current_user.id and application.user_id == @current_user.id
      application.attach(upload)
      flash[:success] = 'File attached'
      redirect_to apply_path(t: application.job.token) and return false
    end
    not_found
  end

  def remove
    return_to = params[:return_to]
    upload = Upload.where(:id => params[:id]).first
    if upload and upload.user_id == @current_user.id
      upload.destroy
      flash[:success] = 'File removed'
      redirect_to return_to and return false
    end
    not_found
  end

  def list
    render :json=> ActiveSupport::JSON.encode(Upload.datatable_user(@current_user.id,params,view_context))
  end

  def attached_list
    render :json=> ActiveSupport::JSON.encode(Upload.datatable_application(params[:application_id].to_i,params,view_context))
  end

  def upload
    accepted_formats = ['.doc', '.docx', '.pdf', '.png', '.jpg', '.jpeg']
    uploaded_io = params[:upload][:file]

    extension = File.extname(uploaded_io.original_filename)
    if accepted_formats.include? extension
      upload = Upload.upload_to_s3(params)
      if upload.save
        flash[:success] = 'File successfully uploaded'
        redirect_to dashboard_path and return true
      else
        flash[:danger] = Utils.get_error_string(upload,'File not uploaded')
        redirect_to dashboard_path and return false
      end
    else
      flash[:danger] = 'Invalid file type. Accepted formats are: doc, docx, pdf, png, jpg, jpeg'
      redirect_to dashboard_path and return false
    end
    redirect_to dashboard_path
  end

  def download
    upload_id = params[:id].to_i
    upload = Upload.find(upload_id)
    if upload
      file = upload.get_file_from_s3
      extension = File.extname(upload.file).slice!(0)
      send_file file,filename: "#{upload.user.first_name}_#{upload.file}",type: "application/#{extension}"
    else
      not_found
    end
  end
end
