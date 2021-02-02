# == Schema Information
#
# Table name: uploads
#
#  id             :integer          not null, primary key
#  upload_type    :integer
#  description    :string(255)
#  url            :string(255)
#  file           :string(255)
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#  application_id :integer
#

class Upload < ApplicationRecord
  belongs_to :user
  belongs_to :application

  before_destroy :delete_s3_resource

  validates :url, :presence => true
  validates :upload_type, :presence => true
  validates :description, :presence => true
  validates :user, :presence => true

  def type_string
    if upload_type == 1
      return 'CV'
    elsif upload_type == 2
      return 'Certificate'
    elsif upload_type == 3
      return 'Other'
    end
  end

  # Check if the s3 resource is referenced by other objects
  def resource_used_by_others?
    count = Upload.where(:file => self.file).count
    if count > 1
      return true
    end
    return false
  end

  def get_file_from_s3
    directory_name = Rails.root.join('public','uploads')
    Dir.mkdir(directory_name) unless File.exists?(directory_name)
    filename =  Rails.root.join(directory_name, self.file)

    if !File.exists?(filename)
      obj = S3_OBJ.bucket(ENV['S3_BUCKET']).object(self.file)
      if obj.exists?
        obj.get({response_target: filename})
      else
        puts "File #{self.file} doesnt exist on Amazon S3"
      end
    end
    filename
  end

  def self.datatable_user(user_id,params,view_context)
    uploads = Upload.where(:user_id => user_id, :application => nil).order(:id => :desc).load.limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
    count = Upload.where(:user_id => user_id, :application => nil).count

    upload_list = []
    uploads.each do |u|
      obj = u.as_json(only:[:description])
      obj['upload_type'] = u.type_string
      if params[:role] == 'upload'
        obj['actions'] = view_context.link_to_download(u.id) +'  '+ view_context.link_to_remove_upload(u.id,params[:return_to])
      elsif params[:role] == 'attachment'
        obj['actions'] = view_context.link_to_attach_upload(u.id,params[:application_id].to_i)
      end

      obj['date'] = view_context.format_date(u.created_at)
      upload_list.push(obj)
    end

    data = Hash.new
    data['sEcho'] = params[:sEcho]
    data['iTotalRecords'] = count
    data['iTotalDisplayRecords'] = count
    data['aaData'] = upload_list
    data
  end

  def self.datatable_application(application_id,params,view_context)
    application = Application.where(:id => application_id).first
    uploads = Upload.where(:application_id => application_id).order(:id => :desc).load.limit(params[:iDisplayLength]).offset(params[:iDisplayStart])
    count = Upload.where(:application_id => application_id).count

    upload_list = []
    uploads.each do |u|
      obj = u.as_json(only:[:description])
      obj['upload_type'] = u.type_string
      if application.get_status == Application.status_complete
        obj['actions'] = view_context.link_to_download(u.id)
      else
        obj['actions'] = view_context.link_to_remove_upload(u.id,params[:return_to])
      end

      upload_list.push(obj)
    end

    data = Hash.new
    data['sEcho'] = params[:sEcho]
    data['iTotalRecords'] = count
    data['iTotalDisplayRecords'] = count
    data['aaData'] = upload_list
    data
  end

  def self.upload_to_s3(params)
    uploaded_io = params[:upload][:file]
    upload_type = params[:upload][:upload_type].to_i
    user_id = params[:upload][:user_id].to_i

    upload = Upload.new
    upload.user_id = user_id
    upload.upload_type = upload_type
    upload.description = params[:upload][:description]

    extension = File.extname(uploaded_io.original_filename)

    directory_name = Rails.root.join('public','uploads')
    Dir.mkdir(directory_name) unless File.exists?(directory_name)

    filename =  Rails.root.join(directory_name, "#{upload_type}_#{user_id}_#{Time.now.to_i}#{extension}")

    File.open(filename, 'wb') do |file|
      file.write(uploaded_io.read)
    end

    key = File.basename(filename)
    obj = S3_OBJ.bucket(ENV['S3_BUCKET']).object(key)
    obj.upload_file(filename)

    puts "************** File uploaded to #{obj.public_url}"

    FileUtils.rm(filename) #delete temporary file

    upload.file = key
    upload.url = obj.public_url
    return upload
  end

  private

  def delete_s3_resource
    if !resource_used_by_others?
      obj = S3_OBJ.bucket(ENV['S3_BUCKET']).object(self.file)
      if obj
        obj.delete
      end
    end
  end
end
